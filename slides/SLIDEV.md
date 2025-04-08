# Slidev Cheat Sheet

## Slide Structure & Markdown
- **Slides as Markdown:** Write slides in a single Markdown file (e.g. `slides.md`), using standard Markdown for content ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=Syntax%20Guide)). 
- **Slide Separation:** Use a horizontal rule `---` on a blank line to separate slides ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=Use%20%60,line%20to%20separate%20your%20slides)). For example: 

  ```markdown
  # Slide 1 Title

  Content of first slide...

  ---

  ## Slide 2 Title

  Content of second slide...
  ``` 

- **Mixed Content:** Within slides you can include **headings, lists, images, code fences**, etc., and even HTML or Vue components. For example, you can apply UnoCSS utility classes or embed components directly in Markdown ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=)).
- **Presenter Notes:** Add notes for a slide by placing an HTML comment at the end of the slide. This content will be visible only in presenter view (not on the slide itself) ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=%3C%21,)).

## YAML Frontmatter (Headmatter & Per-Slide)
- **Headmatter (Global):** The first YAML frontmatter block at the top of the file configures the whole deck ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=At%20the%20beginning%20of%20each,For%20example)). Use it for global settings like title, theme, and add-ons. For example: 

  ```yaml
  ---
  title: "My Presentation"
  theme: seriph        # apply theme (e.g. @slidev/theme-seriph)
  lineNumbers: true    # enable line numbers on all code blocks
  addons:              # include Slidev addons by name
    - '@slidev/plugin-notes'
  ---
  ```
- **Per-Slide Frontmatter:** Each slide can begin with an optional frontmatter to configure that slide ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=layout%3A%20center%20background%3A%20%2Fbackground,white)). Common per-slide options include:
  - `layout`: Use a built-in layout preset (e.g. *center*, *cover*, *two-cols*) for that slide ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=)) ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=yaml)).
  - `class`: Apply custom CSS classes to the slide (e.g. `class: text-white`) ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=layout%3A%20center%20background%3A%20%2Fbackground,white)).
  - `background`: Set a background image or color for the slide (e.g. `background: '/images/bg.png'`) ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=layout%3A%20center%20background%3A%20%2Fbackground,white)).
  - `transition`: Specify a transition for entering/leaving this slide (overrides global transition) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=Slidev%20supports%20slide%20transitions%20out,frontmatter%20option)).
  - `hideInToc`: If `true`, exclude this slide from the generated table of contents ([Components | Slidev](https://sli.dev/builtin/components#:~:text=,of%20the%20slide)).
- **External Slide Content:** Instead of inline content, you can reference an external Markdown file for a slide using `src` in the frontmatter ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=,only%20contains%20a%20frontmatter)). For example: `src: "./section1/intro.md"` will import that file’s content as the slide.

## Layouts & Design
- **Built-in Layouts:** Slidev provides pre-defined layouts to quickly format slides ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=)). Use `layout: <name>` in a slide’s frontmatter to apply. Examples of layout names:
  - **default:** Standard layout (no special positioning) ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=)).
  - **center:** Center-align content both vertically and horizontally ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=)).
  - **cover:** Cover page layout (often used for title slide) ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=)).
  - **two-cols / two-cols-header:** Split content into two columns (optionally with a header row) ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=%60two)) ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=)).
  - **image-left / image-right / image:** Place an image on one side (or full slide) with content on the other ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=%60image)) ([Layouts | Slidev](https://sli.dev/builtin/layouts#:~:text=)).
  - *(Many more layouts are available, e.g. **quote**, **section**, **end**, **full**, **iframe**, etc. — refer to Slidev docs for full list.)*
- **Background & Styling:** In addition to `background` images, you can style slides with:
  - **Utility Classes:** Use UnoCSS (Tailwind-compatible) classes directly in Markdown to style elements (e.g. `class="p-3 text-center"` on a `<div>` or markdown element) ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=)).
  - **Scoped Slide CSS:** Include a `<style>` tag in a slide to define CSS that applies only to that slide. Styles defined in Markdown are *scoped* to the current slide ([Slide Scope Styles | Slidev](https://sli.dev/features/slide-scope-style#:~:text=Slide%20Scope%20Styles)) ([Slide Scope Styles | Slidev](https://sli.dev/features/slide-scope-style#:~:text=,affected)).
  - For truly global custom CSS or overriding theme styles, you can add CSS in the project’s setup (e.g. in `index.css` or a custom theme).

## Animations & Click Transitions
- **Incremental Reveal (Click):** Use the `<VClick>` component or `v-click` directive to make content appear on successive clicks ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=%60v)). Wrapping an element in `<v-click>...</v-click>` (or adding `v-click` to its tag) will hide it initially and reveal it when the presentation advances by one step (click or keypress) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=To%20apply%20show%2Fhide%20,click%60%20directive)). Multiple `v-click` elements on a slide will reveal one by one on each click.
- **Sequential Appearance:** Use `<VAfter>` (or `v-after` directive) for content that should appear *together with* the previous click’s content ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=%60v)). An element with `v-after` stays hidden until *after* the preceding `v-click` has triggered, then it shows up simultaneously on that same step ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=md)).
- **Hide on Click:** Append the `.hide` modifier to a `v-click`/`v-after` to make an element disappear on that click instead of appear ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=Hide%20after%20clicking)). This is useful for hiding an element after a certain step.
- **Custom Motion Animations:** For more advanced element animations, apply the `v-motion` directive (powered by VueUse/Motion) with props for initial/enter/leave transitions ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=%60v,For%20example)) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=%3Cdiv%20v,x%3A%2050)). For example, `v-motion="{ x: 0 }" :initial="{ x: -80 }" :enter="{ x: 0 }"` can animate an element sliding in. You can combine `v-click` with `v-motion` to trigger animated movement on specific click steps ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=Or%20combine%20%60v)).

## Slide Transitions
- **Transition Effects:** Define slide transition animations when navigating between slides by setting `transition` in frontmatter ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=Slidev%20supports%20slide%20transitions%20out,frontmatter%20option)). For example, in a slide’s YAML: `transition: slide-left` will make slides slide horizontally when advancing ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=)) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=%2A%20%60fade%60%20,Via%20the%20view%20transitions%20API)).
- **Built-in Transitions:** Available values include:
  - `fade` (crossfade between slides),
  - `fade-out` (current slide fades out, then next fades in),
  - `slide-left`, `slide-right`, `slide-up`, `slide-down` (slide movement in specified direction) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=%2A%20%60fade%60%20,Via%20the%20view%20transitions%20API)),
  - `view-transition` (uses the new View Transition API for smooth DOM element transitions) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=%2A%20%60slide,Via%20the%20view%20transitions%20API)).
- **Global vs. Per Slide:** Set `transition` in the **headmatter** to apply an effect to all slides by default ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=This%20will%20give%20you%20a,Setting%20it%20in%20the)). You can override on individual slides by specifying a different `transition` in that slide’s frontmatter ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=match%20at%20L614%20headmatter%20will,transitions%20per%20slide%20in%20frontmatters)).
- **Custom & Directional:** You can create **custom transition** names and define their CSS in a global stylesheet (leveraging Vue’s `<Transition>` classes) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=match%20at%20L660%20Slidev%27s%20slide,provide%20your%20custom%20transitions%20by)) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=.my,5%20s%20ease%3B)). Also, you can specify a different transition for forward vs backward navigation using a pipe separator (e.g. `transition: fade|slide-down`) ([Animation | Slidev](https://sli.dev/guide/animations#:~:text=You%20can%20specify%20different%20transitions,separator%20in%20the%20transition%20name)).

## Interactive Code Blocks
- **Embed Code Editor (Monaco):** Turn any code fence into a live Monaco code editor by adding `{monaco}` after the language ID ([Monaco Editor | Slidev](https://sli.dev/features/monaco-editor#:~:text=Whenever%20you%20want%20to%20do,featured%20Monaco%20editor)). For example: 

  ````markdown
  ```ts {monaco}
  console.log('Hello, world')
  ```
  ````

  This will render an interactive TypeScript editor on the slide, allowing you (or the audience) to edit the code.
- **Diff Editor:** Use `{monaco-diff}` to show a side-by-side diff between two code versions ([Monaco Editor | Slidev](https://sli.dev/features/monaco-editor#:~:text=Diff%20Editor)). Separate the original and changed code with `~~~` within the same fenced block. For example: 

  ````markdown
  ```js {monaco-diff}
  const value = 42;
  ~~~
  const value = 84;
  ```
  ````

  This will display a diff highlighting the changes between the two code snippets.
- **Running Code (Monaco Run):** Append `{monaco-run}` to a code block to embed an editor with a “Run” button ([Monaco Runner | Slidev](https://sli.dev/features/monaco-run#:~:text=Slidev%20also%20provides%20the%20Monaco,into%20a%20Monaco%20Runner%20Editor)). This **Monaco Runner** will execute the code (JavaScript/TypeScript by default) and display the output below the code ([Monaco Runner | Slidev](https://sli.dev/features/monaco-run#:~:text=)) ([Monaco Runner | Slidev](https://sli.dev/features/monaco-run#:~:text=)). Example: 

  ````markdown
  ```ts {monaco-run}
  console.log('Slidev Rocks!')
  ```
  ````

  The output of the code will appear on the slide. By default it auto-runs on slide entry; you can disable auto execution with an option `{autorun:false}` ([Monaco Runner | Slidev](https://sli.dev/features/monaco-run#:~:text=result%20will%20be%20re,the%20fly)), or delay showing output using `{showOutputAt: '+1'}` to tie it to the click count ([Monaco Runner | Slidev](https://sli.dev/features/monaco-run#:~:text=If%20you%20want%20to%20only,click)).
- *Custom language runners:* Slidev supports JS/TS out-of-the-box; you can configure runners for other languages (Python, etc.) via custom code runner plugins ([Monaco Runner | Slidev](https://sli.dev/features/monaco-run#:~:text=)).

## Code Snippets & Syntax Highlighting
- **Shiki Highlighter:** Code fences (triple ``` ``` blocks) use **Shiki** for syntax highlighting ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=)), providing VS Code-level accuracy for a wide range of languages. Simply specify the language after the opening backticks (e.g. ```js, ```python).
- **Language Support:** Most popular programming languages are supported via Shiki’s TextMate grammars. No additional CSS is needed for highlighting (colors are inlined) ([Configure Highlighter | Slidev](https://sli.dev/custom/config-highlighter#:~:text=Slidev%20uses%20Shiki%20as%20the,also%20provided%20the%20TwoSlash%20support)). You can even include **LaTeX** `$...$` or `$$...$$` for math (powered by KaTeX) ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=LaTeX%20Blocks%20%7B%23latex)), and **Mermaid** or **PlantUML** fenced blocks for diagrams ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=Diagrams%20%7B)).
- **Line Numbers:** To show line numbers in code blocks, set `lineNumbers: true` in the global frontmatter to enable for all code ([Line Numbers | Slidev](https://sli.dev/features/code-block-line-numbers#:~:text=Line%20Numbers)), or on a per-block basis add `{lines:true}` after the language tag ([Line Numbers | Slidev](https://sli.dev/features/code-block-line-numbers#:~:text=You%20can%20enable%20line%20numbering,lines%3A%20true)). You can also offset the numbering with `{startLine:<n>}` ([Line Numbers | Slidev](https://sli.dev/features/code-block-line-numbers#:~:text=setting%20)).
- **Line Highlighting:** Highlight specific lines or ranges by listing them in braces after the language. For example, ```ts {2,5-7}``` will highlight line 2 and lines 5–7 ([Line Highlighting | Slidev](https://sli.dev/features/line-highlighting#:~:text=Line%20Highlighting)). To stage highlights across multiple clicks (incremental code focus), separate groups with `|`. e.g. `{2-3|5|all}` will highlight lines 2-3 first, then on the next click highlight line 5, then highlight the entire block ([Line Highlighting | Slidev](https://sli.dev/features/line-highlighting#:~:text=Dynamic%20Line%20Highlighting)) ([Line Highlighting | Slidev](https://sli.dev/features/line-highlighting#:~:text=This%20will%20first%20highlight%20,and%20lastly%2C%20the%20whole%20block)). You can use `all` as a shorthand to highlight the whole block, or `hide` to initially hide the code block until a click ([Line Highlighting | Slidev](https://sli.dev/features/line-highlighting#:~:text=You%20can%20set%20the%20line,to%20not%20highlight%20any%20line)).
- **Focused Code Diffs:** For live coding presentations, combine line highlighting with `v-click` to draw attention to code changes. (The `*` symbol in place of line numbers can act as a wildcard for dynamic highlighting across clicks ([Line Numbers | Slidev](https://sli.dev/features/code-block-line-numbers#:~:text=)).)

## Theming & Styling
- **Theme Selection:** Choose a theme by name in the deck headmatter: `theme: <name>` ([Theme and Addons | Slidev](https://sli.dev/guide/theme-addon#:~:text=Changing%20the%20theme%20in%20Slidev,option%20in%20your%20headmatter)). Official themes (published as `@slidev/theme-...`) can be referenced by their short name (e.g. `"seriph"` for `@slidev/theme-seriph`), and Slidev will prompt to install if not already present ([Theme and Addons | Slidev](https://sli.dev/guide/theme-addon#:~:text=Theme%20name%20convention)) ([Theme and Addons | Slidev](https://sli.dev/guide/theme-addon#:~:text=%3F%20The%20theme%20%22%40slidev%2Ftheme,Y%2Fn)). Community or local themes can be used via a path or full package name.
- **Customizing Theme:** Themes can provide their own layouts, components, and styles. You can override theme styles by adding your own CSS/SCSS files in the project (the default theme is built on Windi/UnoCSS, so utility classes are often easiest for minor tweaks). For deeper changes, you can “eject” a theme and modify it, or create a custom theme (Slidev provides CLI tools for theme scaffolding).
- **Add-ons:** Slidev add-ons can be enabled in headmatter (under an `addons:` list) to extend functionality (for example, the official Notes plugin for presenter notes, Excalidraw for sketches, etc.) ([Theme and Addons | Slidev](https://sli.dev/guide/theme-addon#:~:text=,notes%27)). Add-ons can inject additional components, layouts, or features – use them as needed for extra capabilities beyond core.
- **Built-in Styles:** Slidev comes pre-loaded with UnoCSS (atomic CSS). This means you can use Tailwind-like class utilities anywhere in your Markdown to style content instantly ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=)). For custom CSS, the `<style>` tag in a slide is scoped ([Slide Scope Styles | Slidev](https://sli.dev/features/slide-scope-style#:~:text=Slide%20Scope%20Styles)), but you may also add global styles by creating a `styles.css` or using the `setup/main.ts` entry to import CSS.

## Useful Components & Directives
- **Content Embed Components:** 
  - `<Tweet id="..."/>` – embed a tweet by ID (shows an interactive Twitter card) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=)).
  - `<Youtube id="VIDEO_ID"/>` – embed a YouTube video by ID (with optional start time) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=)).
  - `<SlidevVideo>` – wrap video content (HTML5 video source tags) in this component for added Slidev controls (like autoplay on slide entry, reset on slide leave, etc.) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=md)) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=,when%20going%20back%20to%20the)).
- **Drawing & Layout Components:** 
  - `<Arrow>` – draw an arrow on the slide by specifying coordinates (useful for annotations) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=)).
  - `<VDrag>` and `<VDragArrow>` – make elements or arrows draggable during the presentation (for live interaction) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=)) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=)).
  - `<Transform>` – apply CSS transforms (scale/rotate) to content easily by wrapping it in this component ([Components | Slidev](https://sli.dev/builtin/components#:~:text=%3CTransform%20%3Ascale%3D)).
- **Slide Navigation Components:** 
  - `<Toc>` – generate a table of contents slide or section listing all slide titles (respects `hideInToc` flags) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=md)).
  - `<SlideCurrentNo>` / `<SlidesTotal>` – display the current slide number or total slide count ([Components | Slidev](https://sli.dev/builtin/components#:~:text=)) (useful for footers or progress indicators).
  - `<Link>` – create a hyperlink to another slide by number or path (for interactive navigation within the deck) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=)).
- **Directives & Extras:** Since slides are essentially Vue single-file components, you can use Vue directives and interpolations:
  - Use reactive bindings like `:class="{active: condition}"` or conditional rendering (`v-if`, `v-for`) directly in your slide markup if needed.
  - Data and methods can be defined globally (in `setup()` via `setup/main.ts`) and used in slides via Vue reactivity.
  - Special Slidev directives: besides `v-click`/`v-after` (covered above), you have `v-present` (to show content only in presenter view) and others via add-ons. The `v-click` family also includes `v-click.group="n"` to group multiple elements in one click, and `<VSwitch>` to cycle through different content blocks on each click ([Components | Slidev](https://sli.dev/builtin/components#:~:text=Animations)) ([Components | Slidev](https://sli.dev/builtin/components#:~:text=component%20and%20its%20children,%28disabled)).
- **Presenter Mode & Export:** Use the **Presenter view** (`Alt+P`) to see slides with notes and timers while presenting ([slidev/docs/guide/syntax.md at main · slidevjs/slidev · GitHub](https://github.com/slidevjs/slidev/blob/main/docs/guide/syntax.md#:~:text=Notes%20%7B)). Slidev can also export slides to PDF or PNG sequence via CLI or UI, using headless Chrome (with options for output resolution, etc.).

