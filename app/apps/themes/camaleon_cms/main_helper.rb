module Themes::CamaleonCms::MainHelper
  def self.included(klass)
    klass.helper_method [:camaleon_cms_draw_links] rescue ""
  end

  def camaleon_cms_settings(theme)
    # here your code on save settings for current site
  end

  def camaleon_cms_on_install_theme(theme)
    lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ut est arcu. Proin ut cursus orci. Maecenas porta tincidunt nulla, id con gueter dolor condimentum at Nullam."
    lorem2 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. <b>Proin ut est arcu. Proin ut cursus orci</b>. <b>Maecenas porta tincidunt nulla, id con gueter dolor condimentum at Nullam.</b>"

    unless current_site.nav_menus.where(slug: "left_main_menu").present?
      menu_left = current_site.nav_menus.create(name: "Camaleon left menu", slug: "left_main_menu", description: "Use #banner #features #expertise #team #counters #gallery #testimonial #pricing #blog #contact #normal as links in home page.")
      menu_left.append_menu_item({label: "Features", type: "external", link: "#features_section"})
      menu_left.append_menu_item({label: "Expertise", type: "external", link: "#expertise_section"})
      menu_left.append_menu_item({label: "Team", type: "external", link: "#team_section"})
    end
    unless current_site.nav_menus.where(slug: "right_main_menu").present?
      menu_right = current_site.nav_menus.create(name: "Camaleon right menu", slug: "right_main_menu", description: "Use #banner #features #expertise #team #counters #gallery #testimonial #pricing #blog #contact #normal as links in home page.")
      item = menu_right.append_menu_item({label: "Gallery", type: "external", link: "#gallery_section"})
      item.append_menu_item({label: "Testimonials", type: "external", link: "#gallery_testimonials"})
      item.append_menu_item({label: current_site.the_posts.first.title, type: "post", link: current_site.the_posts.first.id})
      menu_right.append_menu_item({label: "Pricing", type: "external", link: "#pricing_section"})
      menu_right.append_menu_item({label: "Blog", type: "external", link: "#blog_section"})
      menu_right.append_menu_item({label: "Contact", type: "external", link: "#contact_section"})
    end


    ids = []
    # layout
    pt_layout = current_site.post_types.where(slug: "camaleon_layout").first || current_site.post_types.create(name: "Layout", slug: "camaleon_layout", data_options: {has_summary: false, has_picture: false })
    pt_layout.add_field({name: "Sub title", slug: "sub_title"}, {field_key: "text_box", translate: true})
    pt_layout.add_field({name: "Background Image", slug: "bg", description: "Size (1900px x 900px)."}, {field_key: "image"})
    pt_layout.add_field({name: "Background color", slug: "bg_color", description: ""}, {field_key: "colorpicker", color_format: "rgba"})
    pt_layout.add_field({name: "Pattern", slug: "pattern", description: "Permit to show square pattern as a background."}, {field_key: "checkbox"})
    ids << pt_layout.id

    pt_layout.add_post(title: "Home Slider", post_order: 1, content: "Here will be shown the home slider", settings: {has_keywords: false, skip_fields: ["sub_title", "pattern", "bg", "bg_color"], default_template: "home/banner"})
    pt_layout.add_post(title: "Features", post_order: 2, content: lorem2, settings: {default_template: "home/features"})
    pt_layout.add_post(title: "Expertise", post_order: 3, content: lorem2, settings: {default_template: "home/expertise"})
    pt_layout.add_post(title: "Team", post_order: 4, content: lorem2, settings: {default_template: "home/team"})
    pt_layout.add_post(title: "Counters", post_order: 5, content: lorem2, settings: {default_template: "home/counters", has_content: false, has_keywords: false, skip_fields: ["sub_tite"]}, fields: {pattern: true, bg: 'http://www.reallusion.com/de/images/3dx5/whatsnew/3dx5_features_banner_bg_02.jpg'})
    pt_layout.add_post(title: "Gallery", post_order: 6, content: lorem2, settings: {default_template: "home/gallery"})
    pt_layout.add_post(title: "Testimonials", post_order: 7, content: lorem2, settings: {default_template: "home/testimonials"}, fields: {pattern: true, bg: 'http://www.reallusion.com/de/images/3dx5/whatsnew/3dx5_features_banner_bg_02.jpg'})
    pt_layout.add_post(title: "Pricing", post_order: 8, content: lorem2, settings: {default_template: "home/pricing"})
    pt_layout.add_post(title: "Custom Page", post_order: 10, content: lorem2, settings: {default_template: "home/custom"})
    blog = pt_layout.add_post(title: "Blog", post_order: 11, content: lorem2, settings: {default_template: "home/blog"})
    blog.add_field({name: "Items to Show", slug: "number_items"}, {field_key: "numeric", default_value: 4, required: true})

    pt_layout.add_post(title: "Contact", post_order: 12, content: "#{lorem2} <b>Paste here your contact form shortcode</b>", settings: {default_template: "home/contact"}, fields:{pattern: true, bg:  'http://www.reallusion.com/de/images/3dx5/whatsnew/3dx5_features_banner_bg_02.jpg'})

    # slider
    pt1 = current_site.post_types.where(slug: "camaleon_slider").first || current_site.post_types.create(name: "Home Slider", slug: "camaleon_slider", data_options: {has_picture: false, has_summary: false, has_keywords: false })
    pt1.add_field({name: "Background image", slug: "bg", description: "Size (1520px x 750px)"}, {field_key: "image", required:true})
    pt1.add_field({name: "Shadow Color", slug: "color"}, {field_key: "checkbox"})
    pt1.add_post(title: "Slider 1", fields: {bg: "http://i261.photobucket.com/albums/ii57/mooxisu/uyuni/salarvidrio.jpg"}, content: "<span class=\"creative creative3\">Multi site support</span><p>Create&nbsp;unlimited sites using one dashboard&nbsp;<br><br></p>")
    pt1.add_post(title: "Slider 1", fields: {bg: "http://www.diario-de-un-escalador.com/wp-content/uploads/Escalada20.jpg"}, content: "<span class=\"creative creative3\">Multi language support</span><p> with easy translations editor<br><br></p>")
    ids << pt1.id

    # features
    pt_we_are = current_site.post_types.where(slug: "camaleon_features").first || current_site.post_types.create(name: "Features", slug: "camaleon_features", data_options: {has_picture: false })
    pt_we_are.add_field({name: "Icon", slug: "icon", description: "Use an icon from font awesome"}, {field_key: "text_box", default_value: "fa-dashboard", required:true})
    pt_we_are.add_post(title: "Multi site", summary: lorem, content: lorem2, fields: {icon: "fa-cubes"})
    pt_we_are.add_post(title: "Multi Language", summary: lorem, content: lorem2, fields: {icon: "fa-cubes"})
    pt_we_are.add_post(title: "Plugins", summary: lorem, content: lorem2, fields: {icon: "fa-language"})
    pt_we_are.add_post(title: "Themes", summary: lorem, content: lorem2, fields: {icon: "fa-cubes"})
    ids << pt_we_are.id

    # expertise
    pt2 = current_site.post_types.where(slug: "camaleon_expertise").first ||  current_site.post_types.create(name: "Expertise", slug: "camaleon_expertise", data_options: {has_summary: false, has_picture: true })
    pt2.add_field({name: "Percentage", slug: "percentage"}, {field_key: "numeric", required:true})
    pt2.add_post(title: "Ruby on Rails", summary: lorem, content: lorem2, fields: {percentage: 99})
    pt2.add_post(title: "PHP", summary: lorem, content: lorem2, fields: {percentage: 99})
    pt2.add_post(title: "JAVA", summary: lorem, content: lorem2, fields: {percentage: 20})
    pt2.add_post(title: "HTML 5", summary: lorem, content: lorem2, fields: {percentage: 99})
    ids << pt2.id

    # team
    pt3 = current_site.post_types.where(slug: "camaleon_team").first || current_site.post_types.create(name: "Team", slug: "camaleon_team", data_options: {has_picture: false, has_content: false})
    pt3.add_field({name: "Photo", slug: "photo", description: "Resolution 150px x 150px"}, {field_key: "image", required:true})
    pt3.add_field({name: "Role", slug: "role"}, {field_key: "text_box", required:true})
    gr_team = pt3.add_field_group({name: "Social", slug: "social"})
    gr_team.add_field({name: "Facebook", slug: "fb"}, {field_key: "url"})
    gr_team.add_field({name: "Twitter", slug: "tw"}, {field_key: "url"})
    gr_team.add_field({name: "Linkedin", slug: "lk"}, {field_key: "url"})
    pt3.add_post(title: "Owen Peredo", summary: lorem, fields: {photo: "https://pbs.twimg.com/profile_images/378800000574190399/fa587847dddb784a8baf3f75e8c3c9b7.jpeg", role: "Camaleon CMS Creator", fb: "https://www.facebook.com/owenperedo", tw: "https://twitter.com/owenperedo", lk: "https://bo.linkedin.com/in/owenperedo"})
    pt3.add_post(title: "Jon Doe", summary: lorem, fields: {role: "Web Developer"})
    pt3.add_post(title: "Owen Peredo", summary: lorem, fields: {photo: "https://pbs.twimg.com/profile_images/378800000574190399/fa587847dddb784a8baf3f75e8c3c9b7.jpeg", role: "Camaleon CMS Creator", fb: "https://www.facebook.com/owenperedo", tw: "https://twitter.com/owenperedo", lk: "https://bo.linkedin.com/in/owenperedo"})
    pt3.add_post(title: "Jon Doe2", summary: lorem, fields: {role: "Web Developer"})
    pt3.add_post(title: "Owen Peredo", summary: lorem, fields: {photo: "https://pbs.twimg.com/profile_images/378800000574190399/fa587847dddb784a8baf3f75e8c3c9b7.jpeg", role: "Camaleon CMS Creator", fb: "https://www.facebook.com/owenperedo", tw: "https://twitter.com/owenperedo", lk: "https://bo.linkedin.com/in/owenperedo"})
    pt3.add_post(title: "Jon Doe2", summary: lorem, fields: {role: "Web Developer"})
    ids << pt3.id

    # counters
    pt4 = current_site.post_types.where(slug: "camaleon_counters").first || current_site.post_types.create(name: "Counters", slug: "camaleon_counters", data_options: {has_summary: false, has_picture: false })
    pt4.add_field({name: "Number count", slug: "count"}, {field_key: "numeric", required:true})
    pt4.add_post(title: "Clients", fields:{count: 90})
    pt4.add_post(title: "Projects", fields:{count: 120})
    pt4.add_post(title: "Friends", fields:{count: 1120})
    ids << pt4.id

    # gallery
    pt_gallery = current_site.post_types.where(slug: "camaleon_gallery").first || current_site.post_types.create(name: "Gallery", slug: "camaleon_gallery", data_options: {has_content: false, has_summary: false, has_picture: false, has_category: true, has_keywords: false })
    cat1 = pt_gallery.categories.create({name: 'Photos', slug: 'photos'})
    cat2 = pt_gallery.categories.create({name: 'Videos', slug: 'videos'})
    pt_gallery.add_field({name: "Thumbnail", slug: "thumb", description: "Size (390px x 315px)"}, {field_key: "image", required:true})
    pt_gallery.add_field({name: "Gallery File (image or video)", slug: "file"}, {field_key: "file", required:true, formats: "video,audio,image"})
    pt_gallery.add_post(title: "Item 1", categories: [cat1.id, cat2.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE"})
    pt_gallery.add_post(title: "Item 2", categories: [cat1.id, cat2.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE", thumb: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Vista_del_Salar_de_Uyuni.JPG/245px-Vista_del_Salar_de_Uyuni.JPG"})
    pt_gallery.add_post(title: "Item 2", categories: [cat1.id, cat2.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE", thumb: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Vista_del_Salar_de_Uyuni.JPG/245px-Vista_del_Salar_de_Uyuni.JPG"})
    pt_gallery.add_post(title: "Item 3", categories: [cat1.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE"})
    pt_gallery.add_post(title: "Item 4", categories: [cat2.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE", thumb: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Vista_del_Salar_de_Uyuni.JPG/245px-Vista_del_Salar_de_Uyuni.JPG"})
    pt_gallery.add_post(title: "Item 4", categories: [cat2.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE", thumb: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Vista_del_Salar_de_Uyuni.JPG/245px-Vista_del_Salar_de_Uyuni.JPG"})
    pt_gallery.add_post(title: "Item 5", categories: [cat2.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE"})
    pt_gallery.add_post(title: "Item 5", categories: [cat2.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE"})
    pt_gallery.add_post(title: "Item 6", categories: [cat1.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE", thumb: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Vista_del_Salar_de_Uyuni.JPG/245px-Vista_del_Salar_de_Uyuni.JPG"})
    pt_gallery.add_post(title: "Item 6", categories: [cat1.id], fields: {file: "https://www.youtube.com/watch?v=r2MOXksZ2UE", thumb: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Vista_del_Salar_de_Uyuni.JPG/245px-Vista_del_Salar_de_Uyuni.JPG"})
    ids << pt_gallery.id

    # testimonials
    pt_test = current_site.post_types.where(slug: "camaleon_testimonial").first || current_site.post_types.create(name: "Testimonials", slug: "camaleon_testimonial", data_options: {has_summary: false, has_picture: false})
    pt_test.add_post(title: "Test 1", content: lorem2)
    pt_test.add_post(title: "Test 1", content: lorem2)
    pt_test.add_post(title: "Test 1", content: lorem2)
    pt_test.add_post(title: "Test 1", content: lorem2)
    ids << pt_test.id

    # pricing
    pt_pricing = current_site.post_types.where(slug: "camaleon_pricing").first ||  current_site.post_types.create(name: "Pricing", slug: "camaleon_pricing", data_options: {has_summary: false, has_picture: true })
    pt_pricing.add_field({name: "Price title", slug: "price"}, {field_key: "text_box", required:true, translate: true})
    pt_pricing.add_field({name: "Details", slug: "details"}, {field_key: "text_box", required:true, translate: true, multiple: true})
    pt_pricing.add_field({name: "Button Label", slug: "btn_label"}, {field_key: "text_box", required:true, translate: true, default_value: "Sign Up Now"})
    pt_pricing.add_post(title: "Basic Plan", fields:{price: "90 $us", details: ["Lorem ipsum dolor", "Test 1 ipsum dolor", "Test 2 ipsum dolor", "Lorem ipsum dolor"], btn_label: "Buy"})
    pt_pricing.add_post(title: "Medium Plan", fields:{price: "120 $us", details: ["Lorem ipsum dolor", "Test 1 ipsum dolor", "Test 2 ipsum dolor", "Lorem ipsum dolor"], btn_label: "Buy"})
    pt_pricing.add_post(title: "Platinum Plan", fields:{price: "220 $us", details: ["Lorem ipsum dolor", "Test 1 ipsum dolor", "Test 2 ipsum dolor", "Lorem ipsum dolor"], btn_label: "Buy"})
    ids << pt_pricing.id

    # clients
    #pt_client = current_site.post_types.where(slug: "camaleon_clients").first || current_site.post_types.create(name: "Clients", slug: "camaleon_clients", data_options: {has_summary: false, has_picture: false})
    #pt_client.add_field({name: "Logo", content: lorem2, slug: "logo", description: "Size (120px x 50px)"}, {field_key: "image", required:true})
    #pt_client.add_post(title: "Google", content: lorem2, fields: {logo: 'https://www.digifloor.com/wp-content/uploads/2013/10/google-logo.png'})
    #pt_client.add_post(title: "Facebook", content: lorem2, fields: {logo: 'https://www.facebookbrand.com/img/fb-art.jpg'})
    #pt_client.add_post(title: "Linkedin", content: lorem2, fields: {logo: 'https://static.licdn.com/scds/common/u/images/logos/linkedin/logo_in_nav_44x36.png'})
    #pt_client.add_post(title: "Twitter", content: lorem2, fields: {logo: 'https://g.twimg.com/Twitter_logo_blue.png'})
    #ids << pt_client.id

    # docs
    pt_docs = current_site.post_types.where(slug: "docs").first || current_site.post_types.create(name: "Documentation", slug: "docs", data_options: {has_summary: false, has_picture: false})
    ids << pt_docs.id

    # settings
    theme.add_field({name: "Theme Color", slug: "theme"}, {field_key: "select", multiple_options: [
        {title: "Orange", value: "orange", default: true},
        {title: "Red", value: "red"},
        {title: "Blue", value: "blue"},
        {title: "Green", value: "green"},
        {title: "Yellow", value: "yellow"}
    ]})
    theme.add_field({"name"=>"Internal pages background image", "slug"=>"inner_bg", description: "Size (1600px x 260px)"},{field_key: "image" })
    theme.add_field({"name"=>"Google Analytics", "slug"=>"analytics", description: "Enter your google analytics code."},{field_key: "text_area", translate: true })

    # theme.add_field({"name"=>"Home Contact form", "slug"=>"home_contact", description: "Past the shortcode of your contact form"},{field_key: "text_box", translate: true})
    theme.add_field({"name"=>"Footer description", "slug"=>"footer_descr"},{field_key: "editor", translate: true})
    theme.save_field_value("footer_descr", "Copyright &copy; 2015 Camaleon. All rights reserved.")

    # social
    gr = theme.add_field_group({name: "Social links", slug: "social"})
    gr.add_field({"name"=>"Title", "slug"=>"social_label"},{field_key: "text_box", translate: true, }); theme.save_field_value("social_label", "Connect with us")
    gr.add_field({"name"=>"Facebook Url", "slug"=>"fb_url"},{field_key: "url"})
    gr.add_field({"name"=>"Twitter Url", "slug"=>"tw_url"},{field_key: "url"})
    gr.add_field({"name"=>"Google Url", "slug"=>"gl_url"},{field_key: "url"})
    gr.add_field({"name"=>"Instagram Url", "slug"=>"in_url"},{field_key: "url"})
    gr.add_field({"name"=>"Youtube Url", "slug"=>"yt_url"},{field_key: "url"})
    gr.add_field({"name"=>"Linkedin Url", "slug"=>"lk_url"},{field_key: "url"})
    gr.add_field({"name"=>"Github Url", "slug"=>"gt_url"},{field_key: "url"})

    theme.set_meta("pt_created", ids)
  end

  def camaleon_cms_on_uninstall_theme(theme)
    current_site.post_types.where(id: theme.get_meta("pt_created")).destroy_all
    current_site.nav_menus.where(slug: ["left_main_menu", "right_main_menu"]).destroy_all
    theme.destroy
  end

  def camaleon_cms_draw_links
    res = []
    if (l = current_theme.get_field("fb_url")).present?
      res << '<a href="'+l+'" class="fb animate bounceIn" data-delay="1400"><i class="fa fa-facebook"></i></a>'
    end
    if (l = current_theme.get_field("tw_url")).present?
      res << '<a href="'+l+'" class="fb animate bounceIn" data-delay="1400"><i class="fa fa-twitter"></i></a>'
    end
    if (l = current_theme.get_field("gl_url")).present?
      res << '<a href="'+l+'" class="fb animate bounceIn" data-delay="1400"><i class="fa fa-google-plus"></i></a>'
    end
    if (l = current_theme.get_field("in_url")).present?
      res << '<a href="'+l+'" class="fb animate bounceIn" data-delay="1400"><i class="fa fa-instagram"></i></a>'
    end
    if (l = current_theme.get_field("yt_url")).present?
      res << '<a href="'+l+'" class="fb animate bounceIn" data-delay="1400"><i class="fa fa-youtube"></i></a>'
    end
    if (l = current_theme.get_field("lk_url")).present?
      res << '<a href="'+l+'" class="fb animate bounceIn" data-delay="1400"><i class="fa fa-linkedin"></i></a>'
    end
    if (l = current_theme.get_field("gt_url")).present?
      res << '<a href="'+l+'" class="fb animate bounceIn" data-delay="1400"><i class="fa fa-github"></i></a>'
    end
    res.join("")
  end

  #{field: ob, form: form, template: temp }
  def camaleon_cms_contact(args)
    args[:template] = "[ci]"
    args[:custom_class] += " animate bounceIn "
    args[:custom_attrs]["data-delay"] = "500"
    args[:custom_attrs]["placeholder"] = args[:field][:label]
  end

  def camaleon_cms_contact_render(args)
    args[:submit] = "<label><span>&nbsp;</span>
                          <button class='submit_btn animate swing' data-delay='1000' id='submit_btn'>[submit_label]</button>
                      </label>"
    args[:before_form] = "<div class='contact'> <div class='form form3 animate bounceInUp'>  <fieldset id='contact_form'>"
    args[:after_form] = "</fieldset> </div> </div>"
  end

  def camaleon_cms_front_before()
    breadcrumb_add("<i class='fa fa-home'></i>", current_site.the_url)
    shortcode_add("bootstrap_slider", "partials/bootstrap_slider")
    shortcode_add("redirect", lambda{|attrs, args| return "<script>window.location.href='#{attrs["url"]}';</script>"; })
  end

  # customize results for docs
  def camaleon_cms_on_render_search(args)
    if params[:mode] == "docs_search"
      args[:posts] = current_site.the_posts("docs").where("title LIKE ? OR content_filtered LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
      args[:render] = 'docs_search'
    end
  end

  def camaleon_cms_on_nav_menu_custom(args)
    args[:custom_menus][:features] = {link: '#features_section', title: "Features"}
    args[:custom_menus][:expertise] = {link: '#expertise_section', title: "Expertise"}
    args[:custom_menus][:team] = {link: '#team_section', title: "Team"}
    args[:custom_menus][:counters] = {link: '#counters_section', title: "Counters"}
    args[:custom_menus][:gallery] = {link: '#gallery_section', title: "Gallery"}
    args[:custom_menus][:blog] = {link: '#blog_section', title: "Blog"}
    args[:custom_menus][:contact] = {link: '#contact_section', title: "Contact"}
  end
end
