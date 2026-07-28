#!/bin/bash
# ==============================================================================
# 🚀 AUTOMATIC FRAMER SYNC SCRIPT
# ==============================================================================
# HOW TO USE THIS SCRIPT:
# 1. Open your Framer canvas and make your design changes (or update resume link).
# 2. Click "Publish" on your Framer site (actuallyaakash.framer.website).
# 3. Open your terminal in this folder and simply run: 
#      ./update-site.sh
# 
# That's it! It is fully automated. This script will automatically download the 
# fresh pages, remove the Framer badges, and push it to Vercel for you.
# ==============================================================================

echo "🚀 Starting automatic site update from Framer..."

# 1. Prepare directories
echo "📁 Creating directories..."
mkdir -p blogs/clarity-over-scroll blogs/evolution-not-erasure blogs/machinery-beneath blogs/designing-internal-dashboards blogs/silent-hand-visual-hierarchy blogs/branding-institutional-scale blogs/designing-for-decisions blogs/less-but-better
mkdir -p works/all-in-notion works/solace works/iiad works/iiad-course-page-redesign works/llf works/destello

# 2. Download all pages
echo "📥 Downloading fresh pages..."
curl -sSL -o index.html https://actuallyaakash.framer.website/
curl -sSL -o works/index.html https://actuallyaakash.framer.website/works
curl -sSL -o blogs/index.html https://actuallyaakash.framer.website/blogs

# Blogs
curl -sSL -o blogs/clarity-over-scroll/index.html https://actuallyaakash.framer.website/blogs/clarity-over-scroll
curl -sSL -o blogs/evolution-not-erasure/index.html https://actuallyaakash.framer.website/blogs/evolution-not-erasure
curl -sSL -o blogs/machinery-beneath/index.html https://actuallyaakash.framer.website/blogs/machinery-beneath
curl -sSL -o blogs/designing-internal-dashboards/index.html https://actuallyaakash.framer.website/blogs/designing-internal-dashboards
curl -sSL -o blogs/silent-hand-visual-hierarchy/index.html https://actuallyaakash.framer.website/blogs/silent-hand-visual-hierarchy
curl -sSL -o blogs/branding-institutional-scale/index.html https://actuallyaakash.framer.website/blogs/branding-institutional-scale
curl -sSL -o blogs/designing-for-decisions/index.html https://actuallyaakash.framer.website/blogs/designing-for-decisions
curl -sSL -o blogs/less-but-better/index.html https://actuallyaakash.framer.website/blogs/less-but-better

# Works
curl -sSL -o works/all-in-notion/index.html https://actuallyaakash.framer.website/works/all-in-notion
curl -sSL -o works/solace/index.html https://actuallyaakash.framer.website/works/solace
curl -sSL -o works/iiad/index.html https://actuallyaakash.framer.website/works/iiad
curl -sSL -o works/iiad-course-page-redesign/index.html https://actuallyaakash.framer.website/works/iiad-course-page-redesign
curl -sSL -o works/llf/index.html https://actuallyaakash.framer.website/works/llf
curl -sSL -o works/destello/index.html https://actuallyaakash.framer.website/works/destello

# 3. Apply CSS patch using python inline script
echo "🛠️  Applying patches to hide Framer badges..."
python3 -c '
import os
patch = """<style>#__framer-badge-container, #__framer-edit-button, .framer-edit-button, [data-framer-component-type="Button"] a[href*="framer.com/"], a[href*="framer.com/projects/"] { display: none !important; pointer-events: none !important; }</style>"""
target = """<script>try{if(localStorage.getItem("__framer_force_showing_editorbar_since")){const n=document.createElement("link");n.rel="modulepreload";n.href="https://framer.com/edit/init.mjs";document.head.appendChild(n)}}catch(e){}</script>"""
files = [
    "index.html", "works/index.html", "blogs/index.html",
    "blogs/clarity-over-scroll/index.html", "blogs/evolution-not-erasure/index.html",
    "blogs/machinery-beneath/index.html", "blogs/designing-internal-dashboards/index.html",
    "blogs/silent-hand-visual-hierarchy/index.html", "blogs/branding-institutional-scale/index.html",
    "blogs/designing-for-decisions/index.html", "blogs/less-but-better/index.html",
    "works/all-in-notion/index.html", "works/solace/index.html", "works/iiad/index.html",
    "works/iiad-course-page-redesign/index.html", "works/llf/index.html", "works/destello/index.html"
]
for f in files:
    if os.path.exists(f):
        with open(f, "r") as file: content = file.read()
        if target in content:
            with open(f, "w") as file: file.write(content.replace(target, patch))
'

# 4. Push to GitHub/Vercel
echo "☁️  Pushing updates to live site..."
git add .
git commit -m "Automated sync of all pages from Framer"
git push

echo "✅ All done! Vercel is building your new site now."
