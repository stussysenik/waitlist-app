module MetaTagsHelper
  def meta_tags
    tags = []
    title = content_for(:title).presence || "WaitlistApp"
    description = content_for(:meta_description).presence || "Create viral waitlist landing pages. Collect emails, enable referrals, and track growth with real-time analytics."
    image = content_for(:og_image).presence || "/og-default.png"
    url = request.original_url

    # Open Graph
    tags << tag.meta(property: "og:title", content: title)
    tags << tag.meta(property: "og:description", content: description)
    tags << tag.meta(property: "og:image", content: image)
    tags << tag.meta(property: "og:url", content: url)
    tags << tag.meta(property: "og:type", content: "website")
    tags << tag.meta(property: "og:site_name", content: "WaitlistApp")

    # Twitter Card
    tags << tag.meta(name: "twitter:card", content: "summary_large_image")
    tags << tag.meta(name: "twitter:title", content: title)
    tags << tag.meta(name: "twitter:description", content: description)
    tags << tag.meta(name: "twitter:image", content: image)

    safe_join(tags, "\n")
  end
end
