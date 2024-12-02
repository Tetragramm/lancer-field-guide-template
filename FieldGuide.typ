#import "@preview/cetz:0.3.1"
#import "@preview/hydra:0.5.1": hydra, anchor

#import "Characters.typ": *

#let regex-fakeitalic(reg-exp: "\b.+?\b", ang: -18.4deg, s) = {
  show regex(reg-exp): it => {
    box(skew(ax: ang, reflow: false, it))
  }
  s
}

#set page(header:anchor())

#let SectionNumber(level:1, ..args) = {
  let h = hydra(level, skip-starting: false, ..args)
  if(h == none){
    []
  } else if (h.fields().at("text", default: "").len() > 0) {
    [#h.text]
  } else if (h.has("children")) {
    [#h.at("children").at(0)]
    // SectionNumber(h)
  } else {
    [#h]
  }
}

#let SectionName(level:1, ..args) = {
  let h = hydra(level, skip-starting: false, ..args)
  if(h == none){
    []
  } else if (h.fields().at("text", default: "").len() > 0) {
    [#h.text]
  } else if (h.has("children")) {
    [#h.at("children").at(2)]
  } else {
    [#h]
  }
}

#let DrawPageNumbers() = context {
  if (calc.odd(counter(page).get().first())) {

      align(bottom + right, cetz.canvas(length: 1in, {
        import cetz.draw : *
        let fw = 7.75
        line((0, 0), (fw, 5), stroke: none)
        let clr = red.darken(100% * counter(page).get().first() / counter(page).final().first())
        line((0,0), (0,1), (0 + 1.625,0), close:true, stroke:clr, fill:clr)
        line((0,1.05), (0,1.105), (0 + 1.8,0),(0 + 1.7,0), close:true, stroke:clr, fill:clr)
        content((0 + 0.45, 0.3), [#strong(text(fill: white, size: 16pt)[\[#counter(page).display()\]])])
      }))
      
      if (SectionName().text.len() > 0) {
        place(bottom + left, dx: 0.65in, dy: -0.4in, [*SECTION #SectionNumber() \/\/* #SectionName()])
      }
  } else {
      if (SectionName().text.len() > 0) {
        place(bottom + right, dx: -0.65in, dy: -0.4in, [*SECTION #SectionNumber() \/\/* #SectionName()])
      }
      align(bottom + left, cetz.canvas(length: 1in, {
        import cetz.draw : *
        let fw = 7.75
        line((0, 0), (fw, 5), stroke: none)
        let clr = red.darken(100% * counter(page).get().first() / counter(page).final().first())
        line((fw,0), (fw,1), (fw - 1.625,0), close:true, stroke:clr, fill:clr)
        line((fw,1.05), (fw,1.105), (fw - 1.8,0),(fw - 1.7,0), close:true, stroke:clr, fill:clr)
        content((fw - 0.45, 0.3), [#strong(text(fill: white, size: 16pt)[\[#counter(page).display()\]])])
      }))
  }
}

#let DrawBackground() = context {
if (calc.even(counter(page).get().first())) { //Right
      place(
        top + right,
        dx: 0.1in,
        dy: 5%,
        stack(dir: ltr, spacing: 0.2em, rotate(-90deg, reflow: true, [*#upper(SectionName(level:2, use-last:true))*]), [
          #set heading(numbering: "1")
          #text(size: 72pt, fill: red.lighten(60%), [
            *#SectionNumber()*
          ])
        ]),
      )
    }
}


#let lightestred = color.rgb(225, 72, 75)
#let cherryred = color.rgb(209, 27, 32)
#let red = color.rgb(194, 31, 37)
#let deepred = color.rgb(143, 0, 1)
#let darkred = color.rgb(100, 10, 13)
#let darkerred = color.rgb(69, 3, 4)
#let darkestred = color.rgb(52, 0, 0)
#let tablegrey = color.rgb(224, 226, 229)
#let gearbrown = color.rgb(75, 0, 13)
#let downtimetan = color.rgb(143, 80, 54)
#let combatcharcoal = color.rgb(34, 30, 31)
#let downtimetan = color.rgb(143, 80, 54)
#let weaponblack = color.rgb(0, 0, 0)
#let protocolorange = color.rgb(199, 89, 0)
#let actiongreen = color.rgb(103, 188, 69)
#let reactionteal = color.rgb(10, 118, 117)
#let talentblue = color.rgb(58, 129, 195)
#let techactionplum = color.rgb(125, 36, 119)
#let narrativepurple = color.rgb(135, 0, 127)

/// Defines the Lancer template
///
/// - Title (str): Title of the document. Goes in metadata and on title page.
/// - Author (str): Author(s) of the document. Goes in metadata and on title page.
/// - CoverImg (bytes): Image to make the first page of the document.
/// - Description (str): Text to go with the title on the title page.
/// - Dedication (str): Dedication to go down below the title on the title page.
/// - body (content)
/// -> content
#let Lancer(Title: str, Author: str, CoverImg: none, Description: "Field Guide to Something", Dedication: "", body) = {
  //Set PDF Metadata
  set document(title: Title, author: Author)
  //Set Default Font document settings
  set text(font: "Arimo", size: 10pt)
  set text(costs: (hyphenation: 300%))
  set par(leading: 0.5em, spacing:1.5em)
  set par(justify: true)
  set list(indent:0pt, body-indent:1.5em)
  set enum(indent: 1em)
  set heading(numbering: (..n) => numbering("1", n.pos().first() - 1, ..n.pos().slice(1)))
  show par: it => block(breakable: false)[#it]
   
  //Create default page format
  set page(paper: "us-letter", header: anchor(), columns: 2, background: DrawBackground(), footer: DrawPageNumbers(), margin: (x:0.75in, top:0.5in, bottom:0.8in))
   
   
  counter(page).update(0)
  //Place CoverImage, if it exists
  if (CoverImg != none) {
    page(margin: 0pt, header:anchor(), footer:none, foreground:none, background: none, columns:1)[
      #set image(height: 100%, fit: "stretch")
      #CoverImg
      #hide(place(top, heading(outlined: false, numbering: none, "")))
      #hide(place(top, heading(outlined: false, numbering: none, level:2, "")))
    ]
  }
  //Create Title Page (and eventual TOC)
  set page(numbering: "1")
  let onepage(body) = page(columns: 1, body)
   
  onepage[
    #if (CoverImg == none) {
      hide(place(top, heading(outlined: false, numbering: none, "")))
      hide(place(top, heading(outlined: false, numbering: none, level:2, "")))
    }
    #set align(center)
     
    //Title and description
    #text(size: 24pt)[
      #Title\
      #Description
    ]
     
    #v(1fr)
    //Dedication is optional
    #Dedication
    #v(2fr)
    //And the Author, of course
    #text(size: 24pt)[
      #Author
      #v(1em)
    ]
  ]

  //Style outline
  show outline.entry.where(level: 1): it => {
    v(1em, weak:true)
    box(width:100%)[
      #box(width:100%, fill:red, inset:4pt)[
        #align(left)[#text(size:12pt, fill:white)[*SECTION #it.body.fields().at("children").at(0):*]]
        ]\
      #text(fill:red, hyphenate: false, size:24pt)[*#NoKeyword()[#upper(it.body.fields().at("children").at(2)) #h(1fr) #it.page]*]
    ]
  }
  show outline.entry.where(level:2): it => {
    box(width:100%, text(size:12pt,hyphenate:false,align(left)[*#NoKeyword()[#upper(it.body.fields().at("children").at(2)) #h(1fr) #it.page]*]))
  }
  show outline.entry.where(level:3): it => {
    v(-1.5em);box(align(left)[#h(1.5em) #text(size:10pt,  hyphenate: false)[*#NoKeyword()[#it.body.fields().at("children").at(2) #h(1fr) #it.page]*]])
  }
  outline(depth: 3, indent: 1em, title: none)
   
  // Set up headings (gotta be styled after #outline)
  show heading.where(level: 2): it => {
    pagebreak(weak:true)
    figure(placement:top, scope: "parent", outlined:false,
      align(right,
      cetz.canvas(length: 100%, {
        import cetz.draw : *
        line((-0.75,0),(1,0),stroke:white)
        line((-0.75in,0),(0.95,0),(0.95,-0.04),(0.92,-0.08),(-0.75in, -0.08), close:true, stroke:red, fill:red)
        content((0,-0.04),anchor:"mid-west", [#text(fill:white, size:36pt)[#NoKeyword()[#upper(it.body)]]])
      }))
    )
    v(-1em)
  }

  show heading.where(level: 3): it => {
    block(sticky: true,text(size: 18pt)[#align(left)[#NoKeyword()[#upper(it.body)]]])
  }
  show heading.where(level: 4): it => {
    block(sticky: true,text(size: 14pt)[#align(left)[#NoKeyword()[#upper(it.body)]]])
  }
  show heading.where(level: 5): it => {
    block(sticky: true,text(fill: red)[#align(left)[#NoKeyword()[#upper(it.body)]]])
  }
   
  //Reset Page counter to 1, and let's go!
  pagebreak(to: "even", weak:true)
  
  show: ApplyKeywords
  show: Sanitize
  body
  [#metadata("EOF") <eof>]
}

#let MaybeImage(img, ..args) = if (img != none) {
  [
    #set image(..args)
    #img
  ]
}

#let local-outline(..args) = context { 
  show outline.entry: it => {
    v(0.3em,weak:true)
    [*#upper(it.body.fields().at("children").at(2)) #h(1fr) #it.page*]
  }
  outline(target: selector(heading)
  .after(
    query(
      selector(heading.where(level: 1))
      .before(here())
    ).last().location(),
    inclusive: false
    )
  .before(
    query(
      selector(heading.where(level: 1))
      .after(here()).or(selector(<eof>))
    ).first().location(),
    inclusive: false
    ), 
    ..args
  )
}
#let Section(name, img: none) = context { 
  pagebreak(to: "even", weak:true)
  set page(background: none, footer:none, columns:1, margin:0pt)

  place(top+center, hide()[= #name])
  align(top+left, box(width:200%, height:80%, img)) 
  place(center+bottom,
    box(width:100%, height:20%, fill:white, 
      box(width:100%, height:97.5%, fill:red, inset:0.75in, 
        align(left+horizon, [
          #set text(fill: white, size: 20pt)
          *SECTION #SectionNumber()* \
          #set text(fill: white, size: 48pt)
          *#upper(SectionName())*
          ] 
        ) 
      ) 
    ) 
  )

  pagebreak() 
  align(top+right,box(width:200%, height:80%, img)) 
  place(center+bottom, 
    box(width:100%, height:20%, fill:white, 
      box(width:100%, height:97.5%, fill:red, inset:0.75in, 
        align(left+horizon, [
          #set text(fill: white)
          #set heading(numbering:none)
          #columns(2)[
            #local-outline(title:none,depth:2)
          ]
          ] 
        ) 
      ) 
    ) 
  ) 
}

#let FullPageImageFramed(img) = {
  page(
  background:{
    place(horizon+center,img)
    DrawBackground()
  }, 
  footer:DrawPageNumbers()
  )[]
}

#let FullPageImage(img) = {
  set page(background: img, footer:none)
  page[]
}

#let FullColImage(img) = context {
  set image(width:4.1in, height:11in, fit:"contain")
  colbreak()
  if(here().position().x.inches() < 4.0){
    place(top+left, dy:-0.6in, float:true, scope: "column",img)
  } else {
    place(top+right, dy:-0.6in, float:true, scope: "column", img)
  }
}

#let LancerHeaderCell(body) = {
  text(fill:red, hyphenate: false,[*#NoKeyword(upper(body))*])
}

#let LancerTable(title:str, instructions:str, fill_function: calc.odd, ..tableargs) = {
box(width:100%, fill:red, inset:0.5em,
  box(width:100%, fill:white, inset: 0.5em,
    [
      #text(size:16pt)[*#upper(title)*] #h(1fr) #text(fill:tablegrey.darken(40%))[*#upper(instructions)*]
      #v(-1em)
      #table(stroke:none, align:left,
        fill: (_,y) => if(fill_function(y))
          {tablegrey}
        else 
          { white },
        ..tableargs
        )
    ]
  )
)
}

#let LoreBox(body) = {
 box(fill:red, inset:0.8em, strong(text(fill:white, body)))
}

#let TitleBox(clr:color, drawing:none, title, title_tech) = {
  layout(size => {
  cetz.canvas(length: 100%, {
    import cetz.draw:* 

    let special-rect(element, name: none) = group(ctx => {
      let w = cetz.util.resolve-number(ctx, 1)
      let (_, n, s) = cetz.coordinate.resolve(ctx, element + ".north", element + ".south")
      let h = cetz.vector.dist(n,s)
      let a = cetz.util.resolve-number(ctx,0.75cm)
      if(h < cetz.util.resolve-number(ctx,1cm) and drawing != none){
        h = cetz.util.resolve-number(ctx,1cm)
      } else if(drawing == none) {
        a = 0
      }
      fill(clr)
      stroke(none)
      line((0,0), (w,0), (w,h - a),
        (w - a + 0.003, h - a + 0.003),
        (w - a + 0.003, h),
        (0, h))
      set-viewport((w - a,h - a),(w,h))
      drawing
    }, name: name)
  
  
    content((0, 0), anchor: "south-west",
            align(left + horizon, box(width:0.9*size.width,inset:(x: 0.5em, y: .3em),[
              #text(fill:white, hyphenate: false, size:12pt,[*#NoKeyword(title)*])
              #if(title_tech != none){
                linebreak()
                AutoSymbolize(text(fill:white, font:"Ubuntu Mono",hyphenate:false,NoKeyword(title_tech)));sym.zws
              }
            ])),
            name: "content")
    on-layer(-1, special-rect("content", name: "my-rect"))
})})
}

//TODO: Make this like the TitleBox
#let ContentBox(clr:color, clip:"bottom-right", txt:none, flavor_text:none) = {
  [#box(fill:clr.lighten(90%),width:100%,inset:(x: 0.5em, top:0.3em, bottom: .5em),[
    #set par(spacing:0.0em)
    #AutoSymbolize(txt)
    #if(txt != none and flavor_text != none and flavor_text != ""){
      repeat[.]+linebreak()
    }
    #text(font:"Ubuntu Mono",NoKeyword(emph(flavor_text)))
    #if(clip == "top-right"){
      place(top+right, dx:1em, dy:-0.65em,
      cetz.canvas(length:100%, {
        import cetz.draw: *
        line((1,0),(0.93,0.0431),(1,0.0431), close:true, fill:white, stroke:none)
      }))
    }
  ])
  #if(clip == "bottom-right"){
    place(bottom+right, cetz.canvas(length:100%, {
      import cetz.draw: *
      line((0,0),(1,0), stroke:none)
      line((1,0),(0.93,-0.0431),(1,-0.0431), close:true, fill:white, stroke:none)
    }))
  }
  ]
}

#let Infobox(clr:color, title:none, title_tech:none, body:none, flavor_text:none, drawing:none)= {
  box(grid(columns:1, TitleBox(clr:clr, drawing: drawing, title, title_tech),
  ContentBox(clr:clr, txt:body, flavor_text:flavor_text)))
}

#let TechBox(title:none, title_tech:none, body:none, flavor_text:none) = {
  let drawing = {
    import cetz.draw: *
    rect((0,0),(0.5,0.5))
    rect((0.5,0.5),(0.75,0.75))
    rect((0.75,0.75),(1,1))
  }
  Infobox(clr:narrativepurple, title:title, title_tech: title_tech, body:body, flavor_text: flavor_text, drawing: drawing)
}

#let WeaponBox(title:none, title_tech:none, body:none, flavor_text:none) = {
  let drawing = {
    import cetz.draw: *
    merge-path(close:true,{
        line((1,0),(0,0),(0,1),(1,1))
        arc((1,0.9),start:90deg, stop:270deg, radius:0.4, mode:"OPEN")
      },
    )
    arc((1,0.8),start:90deg, stop:270deg, radius:0.3, mode:"PIE")
  }
  Infobox(clr:black, title:title, title_tech: title_tech, body:body, flavor_text: flavor_text, drawing: drawing)
}

#let ProtocolBox(title:none, title_tech:none, body:none, flavor_text:none) = {
  let drawing = {
    import cetz.draw: *
    merge-path(close:true,{
        line((1,0),(0,0),(0,1))
        arc((0.5,1),start:180deg, stop:270deg, radius:0.5, mode:"OPEN")
      },
    )
    arc((0.7,1),start:180deg, stop:270deg, radius:0.3, mode:"PIE")
  }
  Infobox(clr:protocolorange, title:title, title_tech: title_tech, body:body, flavor_text: flavor_text, drawing: drawing)
}

#let ActionBox(title:none, title_tech:none, body:none, flavor_text:none) = {
  let drawing = {
    import cetz.draw: *
    line((1,0.2),(1,0),(0,0),(0,1),(0.2,1))
  }
  Infobox(clr:actiongreen, title:title, title_tech: title_tech, body:body, flavor_text: flavor_text, drawing: drawing)
}

#let PassiveBox(title:none, title_tech:none, body:none, flavor_text:none) = {
  Infobox(clr:red, title:title, title_tech:title_tech, body:body, flavor_text: flavor_text, drawing: none)
}

#let ReactionBox(title:none, title_tech:none, trigger:none, body:none) = {
  let drawing = {
    import cetz.draw: *
    line((1,0.1),(1,0),(0,0),(0,1),(0.1,1))
    line((0,1),(1,1),(1,0.9),(0,0.9),
      (0,0.8),(1,0.8),(1,0.7),(0,0.7),
      (0,0.6),(1,0.6),(1,0.5),(0,0.5),
      (0,0.4),(1,0.4),(1,0.3),(0,0.3),
      (0,0.2),(1,0.2),(1,0.1),(0,0.1)
    )
  }
  if(trigger != none){
    box(grid(columns:1, 
      TitleBox(clr:reactionteal, drawing: drawing, title, title_tech),
      box(width:100%,inset:(x: 0.5em, y: .65em), fill:white)[*Trigger:* #trigger],
      ContentBox(clr:reactionteal, txt:[*Effect:* #body]),
    ))
  } else {
    box(grid(columns:1, 
      TitleBox(clr:reactionteal, drawing: drawing, title, title_tech),
      ContentBox(clr:reactionteal, txt:body),
    ))
  }

}


#let GearBox(title:none, title_tech:none, body:none, flavor_text:none) = {
  let drawing = {
    import cetz.draw: *
    line((1,0.2),(1,0),(0,0),(0,1),(0.2,1))
  }
  Infobox(clr:gearbrown, title:title, title_tech: title_tech, body:body, flavor_text: flavor_text, drawing: drawing)
}

#let AutoBox(activation:str, ..args)= {
  let d = args.named().pairs()
  d = d.filter((a)=>{a.at(1) != none}).to-dict()
  let args = arguments(..d)
  if(activation == "Free" or activation == "Quick" or activation == "Full" or activation == "Other"){
    ActionBox(..args)
  } else if(activation == "Protocol"){
    assert(args.named().at("trigger",default:none) == none, message:"Trigger not none: "+args.named().at("title",default:none))
    ProtocolBox(..args)
  } else if(activation == "Invade" or activation == "Full Tech" or activation == "Quick Tech"){
    TechBox(..args)
  } else if(activation == "Reaction"){
    ReactionBox(..args)
  } else if (activation == "Passive" or activation == "AI"){
    PassiveBox(..args)
  } else {
    [Unknown activation type #activation]
  }
}

#let RedBox(title:[], body) = {
  layout(size => {
    box(width:100%,grid(columns:1, 
        cetz.canvas(length: 100%, {
          import cetz.draw:* 

          let special-rect(element, name: none) = group(ctx => {
            let w = cetz.util.resolve-number(ctx, 1)
            let (_, n, s) = cetz.coordinate.resolve(ctx, element + ".north", element + ".south")
            let h = cetz.vector.dist(n,s)

            fill(red)
            stroke(none)
            line((0,0), (w,0), (w, 0.1 * h),
              (w - 1.463 * h, h),
              (0, h))
          }, name: name)
        

          content((0, 0), anchor: "south-west",
                  box(width:0.9*size.width, inset:(x: 0.3em, y: 0.3em),
                    text(fill:white, hyphenate: false, size:10pt,[*#upper(NoKeyword(title))*])
                  ),
                  name: "content")
          on-layer(-1, special-rect("content", name: "my-rect"))
      }),
      ContentBox(clip:false, clr:red, txt:body)
    ))
  })
}

#let MountBox(title) = {
      box(cetz.canvas(length: 100%, {
        import cetz.draw:* 

        let special-rect(element, name: none) = group(ctx => {
          let (_, n, s, e, w) = cetz.coordinate.resolve(ctx, element + ".north", element + ".south", element + ".east", element + ".west")
          let h = cetz.vector.dist(n,s)
          let w = cetz.vector.dist(e,w)

          fill(red)
          stroke(none)
          line((0,0), (w,0), (w, 0.8 * h),
            (w - 0.325 * h, h),
            (0, h))
        }, name: name)
      
      
        content((0, 0), anchor: "south-west",
                box(inset:(left: 0.3em, right:0.6em, y: 0.3em),
                  text(fill:white, size:10pt,[*#upper(NoKeyword(title))*])
                ),
                name: "content")
        on-layer(-1, special-rect("content", name: "my-rect"))
    }))
}

#let PlaceTalent(talent) = {
  assert(talent.at("name",default:none) != none, message: "talent needs field: name, a string")
  assert(talent.at("description",default:none) != none, message: "talent needs field: description, a content")
  assert(talent.at("ranks",default:none) != none, message: "talent needs field: ranks, an array of 3x(name:string,description:content)")
  assert(talent.ranks.len() == 3, message: "talent needs field: ranks, an array of 3x(name:string,description:content)")
  assert(talent.ranks.at(0).at("name",default:none) != none, message: "talent.ranks.at(0) needs field: name, a string")
  assert(talent.ranks.at(0).at("description",default:none) != none, message: "talent.ranks.at(0) needs field: description, a content")
  assert(talent.ranks.at(1).at("name",default:none) != none, message: "talent.ranks.at(1) needs field: name, a string")
  assert(talent.ranks.at(1).at("description",default:none) != none, message: "talent.ranks.at(1) needs field: description, a content")
  assert(talent.ranks.at(2).at("name",default:none) != none, message: "talent.ranks.at(2) needs field: name, a string")
  assert(talent.ranks.at(2).at("description",default:none) != none, message: "talent.ranks.at(2) needs field: description, a content")

  box(width:100%, fill:talentblue,inset:0.3em, 
    text(size:18pt, fill:white, [*#upper(NoKeyword(talent.name))*])
  )

[#emph(talent.description)]
v(-1em);line(length: 100%,stroke:talentblue+2pt);v(-1em)
text(fill:talentblue, size:16pt, CC.RankOne); text(size:16pt)[*#upper(NoKeyword(talent.ranks.at(0).name))*]
linebreak()
talent.ranks.at(0).description
v(-1em);line(length: 100%,stroke:talentblue+2pt);v(-1em)
text(fill:talentblue, size:16pt, CC.RankTwo); text(size:16pt)[*#upper(NoKeyword(talent.ranks.at(1).name))*]
linebreak()
talent.ranks.at(1).description
v(-1em);line(length: 100%,stroke:talentblue+2pt);v(-1em)
text(fill:talentblue, size:16pt, CC.RankThree); text(size:16pt)[*#upper(NoKeyword(talent.ranks.at(2).name))*]
linebreak()
talent.ranks.at(2).description
}

#let PickFrame(lcp, name) = {
  lcp.frames.find(it => { upper(it.name) == upper(name) })
}

  //Map the Size onto symbol
#let Util-size2char(sz) = {
  if(sz == 0.5){
    CC.SizeHalf
  } else if(sz == 1){
    CC.SizeOne
  } else if(sz == 2){
    CC.SizeTwo
  } else if(sz == 3){
    CC.SizeThree
  } else if (sz == 4){
    CC.SizeFour
  } else {
    "No Character"
  }
}
#let Util-size2num(sz) = {
  if(sz == 0.5){
    "1/2"
  } else if(sz == 1){
    "1"
  } else if(sz == 2){
    "2"
  } else if(sz == 3){
    "3"
  } else if (sz == 4){
    "4"
  } else {
    "No Character"
  }
}

//Json contains just the word, so add "Action" if needed
#let UtilActionText(activation) = {
  if(activation == "Quick" or activation == "Full" or activation == "Free"){
    [#activation Action]
  } else {
    activation
  }
}

#let ParseTags(lcp, tags) = {
  let tech = ()
  for tval in tags {
    
    let tag = lcp.tags.find((t)=>{t.id == tval.id})
    let name = tag.name
    name = name.replace("Heat {VAL} (Self)", "{VAL} Heat (Self)")
    if("val" in tval) {
      name = name.replace("{VAL}", str(tval.val))
    }
    tech.push(name)
  }
  tech
}

#let ParseDeployable(lcp, d)= {
  let procval(val) = {
    if(type(val) == str){
      val = val.replace(regex(" |\{|\}"),"").replace("grit","Grit")
    }
    val
  }
  let dtxt = [*#NoKeyword(d.name) (#d.type*]
  if("range" in d){ // Apply Range(s)
    for rng in d.range {
      dtxt = [#dtxt*, #CC.at(rng.type);#rng.val*]
    }
  }
  if("damage" in d){ // Apply Damage(s)
    let dmglist = ()
    for dmg in d.damage {
      dmglist.push(str(dmg.val)+CC.at(dmg.type))
    }
    dtxt = [#dtxt*, #dmglist.join("+")*]
  }
  if("size" in d){ dtxt = [#dtxt*, Size #Util-size2num(d.size)*]}
  if("hp" in d){ dtxt = [#dtxt*, HP #procval(d.hp)*]}
  if("armor" in d){ dtxt = [#dtxt*, Armor #procval(d.armor)*]}
  if("evasion" in d){ dtxt = [#dtxt*, Evasion #procval(d.evasion)*]}
  if("edef" in d){ dtxt = [#dtxt*, E-Defense #procval(d.edef)*]}
  if("heatcap" in d){ dtxt = [#dtxt*, Heat Cap #procval(d.heatcap)*]}
  if("repcap" in d){ dtxt = [#dtxt*, Repair Cap #procval(d.repcap)*]}
  if("sensor_range" in d){ dtxt = [#dtxt*, Sensors #procval(d.sensor_range)*]}
  if("tech_attack" in d){ dtxt = [#dtxt*, Tech Attack #procval(d.tech_attack)*]}
  if("save" in d){ dtxt = [#dtxt*, Save Target #procval(d.save)*]}
  if("speed" in d){ dtxt = [#dtxt*, Speed #procval(d.speed)*]}
  if("tags" in d){
    dtxt = [#dtxt*, Tags: \[#ParseTags(lcp, d.tags).join(", ")\]*]
  }
  dtxt = [#dtxt*):* #d.detail]

  dtxt
}

//Go from IWeaponProfile to box
//TODO: More thorough testing.
#let ParseWeapon(lcp, weap) = {
  let tech = [#weap.mount #weap.type]
  if("sp" in weap){ //Cost anything?
      tech = [#tech, #weap.sp; SP]
  }
  if("tags" in weap){ //Apply tags
    tech = [#tech, #ParseTags(lcp, weap.tags).join(", ")]
  }
  if("range" in weap){ // Apply Range(s)
    tech = [#tech\ ]
    for rng in weap.range {
      tech = [#tech\[#CC.at(rng.type);#rng.val\]]
    }
  }
  if("damage" in weap){ // Apply Damage(s)
    let dmglist = ()
    for dmg in weap.damage {
      dmglist.push(str(dmg.val)+CC.at(dmg.type))
    }
    if(dmglist.len() > 0){
      tech = [#tech\[#dmglist.join("+")\]]
    }
  }
  // So some weapons have an effect, some have the same effect copied to every profile, some have a different text for every profile.
  // This takes them all, does a deduplicate, and then uses that.
  let eff = ()
  if("effect" in weap){
    eff.push(weap.effect)
  }
  if("on_attack" in weap){
    eff.push([*On Attack:* #weap.on_attack])
  }
  if("on_hit" in weap){
    eff.push([*On Hit:* #weap.on_hit])
  }
  if("on_crit" in weap){
    eff.push([*On Crit:* #weap.on_crit])
  }
  //If the weapon has profiles, 
  let common_tags = ()
  for (idx, prof) in weap.at("profiles", default: ()).enumerate() {
    if(idx == 0) {
      common_tags = ParseTags(lcp, prof.at("tags",default:()))
    }
    let temp_tags = common_tags
    let prof_tags = ParseTags(lcp, prof.at("tags",default:()))
    for t1 in temp_tags {
      if t1 not in prof_tags {
        let r = common_tags.remove(common_tags.position(t => t == t1))
      }
    }
    temp_tags = prof_tags
    for t2 in temp_tags {
      if t2 not in common_tags {
        let r = prof_tags.remove(prof_tags.position(t => t == t2))
      }
    }
    if("on_attack" in prof){
      eff.push([*On Attack:* #prof.on_attack])
    }
    if("on_hit" in prof){
      eff.push([*On Hit:* #prof.on_hit])
    }
    if("on_crit" in prof){
      eff.push([*On Crit:* #prof.on_crit])
    }
  }
  if(common_tags.len() > 0){
    tech = [#tech, #common_tags.join(", ")]
  }
  for (idx, prof) in weap.at("profiles", default: ()).enumerate() {
    if(idx != 0){ tech = [#tech or] }
    tech = [#tech #linebreak()]
    for rng in prof.at("range", default:()) {
      tech = [#tech\[#CC.at(rng.type);#rng.val\]]
    }
    for dmg in prof.at("damage", default:()) {
      tech = [#tech\[#dmg.val#CC.at(dmg.at("type", default:"None"))\]]
    }
    let prof_tags = ParseTags(lcp, prof.at("tags",default:()))
    for t1 in common_tags {
        let r = prof_tags.remove(prof_tags.position(t => t == t1))
    }
    tech = [#tech #prof_tags.join(", ")]
    if("effect" in prof){
      eff.push(prof.effect)
    }
  }
  for d in weap.at("deployables", default:()){
    eff.push(ParseDeployable(lcp, d))
  }
  eff = eff.dedup().join("\n")
  WeaponBox(title:weap.name, title_tech:tech, body:eff, flavor_text: weap.at("description", default:none))
  
  for aa in weap.at("actions",default:()) {
    let tech = aa.at("title_tech", default:[#UtilActionText(aa.activation)])
    AutoBox(activation: aa.activation, title:aa.name, title_tech:tech, trigger:aa.at("trigger",default:none),body:aa.detail)
  }
  for dd in weap.at("deployables",default:()) {
    for aa in dd.at("actions",default:()){
      let tech = aa.at("title_tech", default:[#UtilActionText(aa.activation)])
      AutoBox(activation: aa.activation, title:aa.name, title_tech:tech, trigger:aa.at("trigger",default:none),body:aa.detail)
    }
  }
}

#let ParseDeployableAction(a) = {
  let tags = ()
  if(a.name.contains("Grenade")){
    tags.push([Grenade])
  }
  for r in a.at("range",default:()){
    tags.push([#CC.at(r.type);#r.val])
  }
  for r in a.at("damage", default:()){
    tags.push([#CC.at(r.type);#r.val])
  }
  if(tags.len() > 0){
    [*#NoKeyword(a.name)* _(#tags.join(", "))_: #a.detail]
  } else {
    [*#NoKeyword(a.name):* #a.detail]
  }
}


#let ParseTalent(lcp, name) = {
  let talent = lcp.talents.find(it => { upper(it.name) == upper(name) })

  for (idx,r) in talent.ranks.enumerate() {
    talent.ranks.at(idx).description = AutoSymbolize([#r.description
      #if("actions" in r){
        for act in r.actions {
          if(act.name != r.name or act.at("description",default:"") != r.description){
            AutoBox(activation: act.activation, title:act.name, title_tech:UtilActionText(act.activation), trigger:act.at("trigger",default:none),body:act.detail)
          }
        }
      }
      #if("integrated" in r){
        for w in r.integrated {
          let weap = lcp.weapons.find((w)=>{w.id == w})
          ParseWeapon(lcp, weap)
        }
      }
    ])
  }
  talent
}

//Go from Systems.json to box
#let ParseSystem(lcp, sys) = {
  let tech = ()
  if("sp" in sys){ //Cost anything?
      tech.push([#sys.sp; SP])
  }
  if("tags" in sys){ //Apply tags
    tech = tech+ParseTags(lcp, sys.tags)
  }
  sys.activation = sys.at("activation", default:"Passive")
  // So some weapons have an effect, some have the same effect copied to every profile, some have a different text for every profile.
  // This takes them all, does a deduplicate, and then uses that.
  let eff = ()
  if("effect" in sys){
    let push = true
    for a in sys.at("actions", default:()) {
      if(sys.effect == a.at("detail",default:"")){
        push = false
      }
    }
    for d in sys.at("deployables", default:()) {
      if(sys.effect == d.at("detail",default:"")){
        push = false
      }
    }
    if(push){
      eff.push(sys.effect)
    }
  }
  let utype = upper(sys.at("type", default:"SYSTEM"))
  let sub_actions = false
  if(utype == "DEPLOYABLE" or utype == "DRONE" or utype == "SHIELD" or utype == "SYSTEM") {
    if("actions" in sys or "deployables" in sys){
      if("actions" in sys and sys.actions.at(0).at("name",default:0) == 0){
        let a = sys.actions.at(0)
        tech.insert(0,[#a.activation Action])
        sys.activation = a.activation
        eff.push(a.detail)
      } else if("deployables" in sys and sys.deployables.at(0).at("name",default:0) == 0){
        let a = sys.actions.at(0)
        tech.insert(0,[#a.activation Action])
        sys.activation = a.activation
        eff.push(a.detail)
      }else if("actions" in sys and sys.actions.at(0).at("activation",default:"") == "Reaction"){
        sys.activation = "Passive"
        eff.push("Gain the "+strong(NoKeyword(sys.actions.at(0).name))+" reaction.")
      } else {
        let litems = ()
        for a in sys.at("actions",default:()){
          if(a.at("activation",default:"") != "Reaction"){
            sys.activation = a.at("activation",default:sys.activation)
            litems.push(ParseDeployableAction(a))
          }
        }
        for d in sys.at("deployables",default:()){
          sys.activation = d.at("activation",default:sys.activation)
          litems.push(ParseDeployable(lcp, d))
        }
        if(litems.len() > 1){
          eff.push(linebreak()+list(
            ..litems
          ))
        } else if (litems.len() == 1) {
          eff.push(linebreak()+litems.at(0))
        }
      }
    }
    tech = tech.dedup().join(", ")
    eff = eff.dedup().join(linebreak())
    
    AutoBox(activation:sys.activation, title:sys.name, title_tech:tech, body:eff, flavor_text: sys.at("description", default:none))
    for aa in sys.at("actions",default:()) {
      if("name" in aa and aa.name != sys.name and "activation" in aa and aa.activation == "Reaction"){
        let tech = aa.at("title_tech", default:[#UtilActionText(aa.activation)])
        linebreak()
        AutoBox(activation: aa.activation, title:aa.at("name", default:sys.name), title_tech:tech, trigger:aa.at("trigger",default:none), body:aa.detail)
      }
    }


  } else if (utype == "TECH") {
    if(eff.len() == 0 and sys.at("actions",default:()).len() >= 1) {
      if((sys.actions.at(0).activation == "Invade" or sys.actions.at(0).activation == "Quick Tech" or sys.actions.at(0).activation == "Full Tech") and "name" in sys.actions.at(0)) {
        eff.push("Gain the following "+sys.actions.at(0).activation+" options:")
      } else {
        eff.push(sys.actions.at(0).detail)
      }
      tech.insert(0, sys.actions.at(0).activation)
    }
    for i in sys.at("actions",default:()).filter(iv => ((upper(iv.activation) == "INVADE" or upper(iv.activation) == "QUICK TECH" or upper(iv.activation) == "FULL TECH") and "name" in iv)){
      eff.push(box(width:100%,fill:white, outset:(x: 0.5em), inset:(y:0.65em), stroke:(y:narrativepurple),[
        *#i.name:* #i.detail
      ]))
    }
    tech = tech.dedup().join(", ")
    eff = eff.dedup().join("\n")
    TechBox(title:sys.name, title_tech:tech, body:eff, flavor_text: sys.at("description", default:none))


  } else {
    tech = tech.dedup().join(", ")
    eff = eff.dedup().join("\n")
    PassiveBox(title:sys.name, title_tech:tech, body:eff, flavor_text: sys.at("description", default:none))
    for aa in sys.at("actions",default:()) {
      let tech = aa.at("title_tech", default:[#UtilActionText(aa.activation)])
      block(AutoBox(activation: aa.activation, title:aa.at("name", default:sys.name), title_tech:tech, trigger:aa.at("trigger",default:none), body:aa.detail))
    }
  }
  
  for dd in sys.at("deployables",default:()) {
    for aa in dd.at("actions",default:()){
      let tech = aa.at("title_tech", default:[#UtilActionText(aa.activation)])
      AutoBox(activation: aa.activation, title:aa.name, title_tech:tech, trigger:aa.at("trigger",default:none),body:aa.detail)
    }
  }
  
}

#let ParseMod(lcp, mod) = {
  mod.type = "MOD"
  mod.tags = mod.at("tags",default:())
  mod.tags.push(("id": "tg_mod"))
  let possible_types = ("Melee", "CQB", "Rifle", "Launcher", "Cannon", "Nexus")
  let possible_mounts = ("Auxiliary", "Main", "Heavy", "Superheavy")
  let prefix = "";
  let allowed_types = mod.at("allowed_types",default:possible_types)
  for rt in mod.at("restricted_types",default:()){
    if(rt in allowed_types){
      let r = allowed_types.remove(allowed_types.position(it => it == rt))
    }
  }
  if(possible_types.all(it => it in allowed_types)){
    prefix = "Choose any weapon"
  } else {
    prefix = "Choose a "+allowed_types.join(" or ")+" weapon"
  }
  let allowed_mounts = mod.at("allowed_sizes",default:possible_mounts)
  for rm in mod.at("restricted_sizes",default:()){
    if(rm in allowed_mounts){
      let r = allowed_mounts.remove(allowed_mounts.position(it => it == rm))
    }
  }
  if(possible_mounts.all(it => it in allowed_mounts)){
    prefix = prefix + " on any mount."
  } else {
    prefix = prefix + " on a "+allowed_mounts.join(" or ")+" mount."
  }


  mod.effect = prefix+"\n"+mod.effect
  ParseSystem(lcp, mod)
}


#let PlaceBlocks(frame, content_array, possible_colbreak_idx, figure) = {
    set block(spacing:0.2em)

    layout(sz => {
      // [#sz.height #measure(f, width:504pt).height #measure(CS_Header, width:sz.width).height #linebreak()]
      //TODO: Magic Numbers.  504pt is the width of a page, so it's what the figure uses.  
      // Measured on a blank page and manually typed it in because you can't measure it.
      // -4em is.... No idea, actually.
      sz.height = (sz.height - measure(figure, width:504pt).height -4em).to-absolute()
      //This is to measure the -4em. The bottom should line up with the box.
      // place(line(length: sz.height, angle:90deg, stroke:blue))
      let sizes = content_array.map(c => measure(block(breakable:false,c), width:sz.width)) //List of all the sizes
      let c1 = sz.height //For 1st and 2nd column record the size
      let c2 = sz.height //We'll count down, so init at total size
      let c2idx = -1 //What element tips to 2nd column?, for the 0.2em adjustment
      let newpage_idx = -1 //What element tips to new page?
      let fit_first = false //Does the 1st column primary elements all fit?
      let fit_second = false //Does the 2nd column to new page elements all fit in the column?
      let total_second = 0pt //Running total of 2nd column primary sizes

      for (idx,size) in sizes.enumerate() {
        // [#c1, #c2, #size.height #linebreak()]
        c1 = c1 - size.height //Subtract off the size
        if(idx != 0){ //If it's not the first element in the column, take off another 0.2em
          c1 = (c1 - 0.2em).to-absolute()
        }
        if (c1 < 0pt and c2idx == -1){//If we've hit the end of the column, set the c2idx marker
          c2idx = idx
        }
        if (c1 < 0pt) { // If we've hit the end of the column, it's now on the 2nd column, so take that off.
          c2 = c2 - size.height
        }
        if(idx != c2idx){ //If it's not the first element in the column, take off another 0.2em
          c1 = (c1 - 0.2em).to-absolute()
        }
        if (c2 < 0pt and newpage_idx == -1){ //If we've hit the end of 2nd column, set the marker
          newpage_idx = idx
        }
        //If this is the boundary between Mounts and Core systems, and we're still in the 1st column, mark that it fits
        if(idx == possible_colbreak_idx -1 and c1 > 0pt){ 
          fit_first = true;
        }
        //If it fits and we're not onto a new page, add it to a total of 2nd column primary elements
        if(fit_first and newpage_idx == -1){
          total_second = total_second + size.height + 0.2em 
        }
      }
      //If we didn't hit a new page, set the marker to the end so nothing gets boxed.
      if(newpage_idx == -1){
        newpage_idx = content_array.len()
      }
      //If all the 2nd column primary elements fit into the column, mark that it fits
      if(total_second.to-absolute() <= sz.height){
        fit_second = true;
      }
      // [#c1, #c2, #fit_first, #fit_second, #newpage_idx, #total_second, #sz.height]
      for (idx,c) in content_array.slice(0,newpage_idx).enumerate() {
        //If both 1st and 2nd column elements fit, balance them by adding a colbreak in the appropriate spot.
        if(fit_first and fit_second and idx == possible_colbreak_idx){
          colbreak()
        }
        //Actually place all the elements on the first page, and a label so we know they were actually placed later.
        [#block(c) #label(frame.name+"c_"+str(idx))]
      }
    })

    //Now for the 2nd page
    context {
      //If there are any that were not placed...
      if(query(label(frame.name+"c_"+str(content_array.len()-1))).len() == 0){
        //New page
        pagebreak()
        //Create the blocks with the borders
        block(stroke:red+2pt, outset:8pt, inset:0pt, breakable: true, block(stroke:red+2pt, outset:4pt, inset:0pt, breakable: true,
          //And in it put every element that wasn't already placed.
          for (idx,c) in content_array.enumerate() {
            if(query(label(frame.name+"c_"+str(idx))).len() == 0){
              block(c)
            }
          }
        ))
        //And a little space for the border at the bottom.
        v(2em)
      }
    }
  }
#let CoreSystemParsing(lcp, core_system) = {
    let content_array = ()

    for pa in core_system.at("passive_actions", default:()) {
      let tech = pa.at("title_tech", default:[Passive, #UtilActionText(pa.activation)])
      
      content_array.push(
        AutoBox(activation:pa.activation, title:pa.name, title_tech:AutoSymbolize(tech),trigger:pa.at("trigger", default:none), body:AutoSymbolize(pa.detail))
      )
    }

    if(("passive_effect" in core_system) and not (core_system.passive_name in core_system.at("passive_actions", default:()).map(pa => pa.name))) {
      let body = core_system.passive_effect
      if("deployables" in core_system){
        body = [#body
        #linebreak()
        #linebreak()
        #list(.. core_system.deployables.map(d=>ParseDeployable(lcp, d)))
        ]
      }
      content_array.push(
        PassiveBox(title:core_system.passive_name, body:AutoSymbolize(body))
      )
    }

    content_array.push(
      AutoBox(activation:core_system.activation, title:core_system.active_name, title_tech:[Active (1CP), #UtilActionText(core_system.activation)], trigger:core_system.at("trigger", default:none), body:AutoSymbolize(core_system.active_effect))
    )

    for aa in core_system.at("active_actions",default:()) {
      let tech = aa.at("title_tech", default:[#UtilActionText(aa.activation)])
      content_array.push(
        AutoBox(activation: aa.activation, title:aa.name, title_tech:AutoSymbolize(tech), trigger:aa.at("trigger", default:none), body:AutoSymbolize(aa.detail))
      )
    }

    for weap_id in core_system.at("integrated", default:()) {
      let weap = lcp.weapons.find((w)=>{w.id == weap_id})
      content_array.push(
        ParseWeapon(lcp, weap)
      )
    }

    for weap_id in core_system.at("special_equipment", default:()) {
      let weap = lcp.weapons.find((w)=>{w.id == weap_id})
      content_array.push(
        ParseWeapon(lcp, weap)
      )
    }
    content_array
  }
#let CoreSystemManual(name, description, blocks) = {
    let content_array = ()
    content_array.push([
      #set par(spacing: 1em)
      #block(sticky: true, text(size:18pt)[*CORE SYSTEMS*])
      #block(sticky: true, text(size:16pt, hyphenate:false, upper(strong(NoKeyword(name)))))
      #if (description != none){
        text(font:"Ubuntu Mono", emph((NoKeyword(description))))
      }
    ])

    content_array += blocks
    content_array
  }

#let PlaceMounts(mounts) = {
let content_array = ()
if(mounts.len()>0){
    content_array.push(block(sticky:true,[#v(1em) #text(size:14pt)[*MOUNTS*]]))
    content_array.push([
      #for m in mounts {
        MountBox([#m\ Mount])+h(2em)
      }
      #h(1fr)
    ])
  }
  content_array
}

#let ParseTraits(traits) = {
  let content_array = ()
  for trait in traits{
    if("actions" in trait){
      if(trait.actions.find(a => {a.name == trait.name}) == none){
        content_array.push(block(RedBox(title:trait.name, AutoSymbolize(trait.description))))
      }
      for ta in trait.actions {
        let tech = ta.at("title_tech", default:[#UtilActionText(ta.activation)])
        content_array.push(
          block(AutoBox(activation: ta.activation, title:ta.name, trigger:ta.at("trigger", default:none), title_tech:AutoSymbolize(tech), body:AutoSymbolize(ta.detail)))
        )
      }
    } else {
      content_array.push(block(RedBox(title:trait.name, AutoSymbolize(trait.description))))
    }
  }
  content_array
}


#let PlaceFrame(frame, traits_blocks, mounts, core_system, background:none) = {
  assert(frame.at("name",default:none) != none, message:"frame needs the field: name, a string")
  assert(frame.at("mechtype",default:none) != none, message:"frame needs the field: mechtype, an array of strings with possible values (Artillery, Biological, Controller, Defender, Striker, Support, Balanced)")
  assert(frame.at("source",default:none) != none, message:"frame needs the field: source, a string")
  assert(frame.at("description",default:none) != none, message:"frame needs the field: description, a string")
  assert(frame.at("stats",default:none) != none, message:"frame needs the field: stats, a dictionary")
  assert(frame.stats.at("size",default:none) != none, message:"frame.stats needs the field: size, a number with possible values (0.5, 1, 2, 3, 4)")
  assert(frame.stats.at("armor",default:none) != none, message:"frame.stats needs the field: armor, a number")
  assert(frame.stats.at("hp",default:none) != none, message:"frame.stats needs the field: hp, a number")
  assert(frame.stats.at("repcap",default:none) != none, message:"frame.stats needs the field: repcap, a number")
  assert(frame.stats.at("evasion",default:none) != none, message:"frame.stats needs the field: evasion, a number")
  assert(frame.stats.at("speed",default:none) != none, message:"frame.stats needs the field: speed, a number")
  assert(frame.stats.at("save",default:none) != none, message:"frame.stats needs the field: save, a number")
  assert(frame.stats.at("sensor_range",default:none) != none, message:"frame.stats needs the field: sensor_range, a number")
  assert(frame.stats.at("edef",default:none) != none, message:"frame.stats needs the field: edef, a number")
  assert(frame.stats.at("tech_attack",default:none) != none, message:"frame.stats needs the field: tech_attack, a number")
  assert(frame.stats.at("sp",default:none) != none, message:"frame.stats needs the field: sp, a number")
  assert(frame.stats.at("heatcap",default:none) != none, message:"frame.stats needs the field: heatcap, a number")
  assert(core_system.at("name",default:none) != none, message:"core_system needs the field: name, a string")
  assert(core_system.at("blocks",default:none) != none, message:"core_system needs the field: blocks, an array of blocks representing the core_system, may be empty")


  //Create the statblock. Short little two colum thing.
  //Matches the stats from frames.json
  let StatBlock(stats) = {
    columns(2)[
      #set text(size:11pt, font:"Ubuntu Mono")
      *Size:* #Util-size2num(stats.size)\
      *Armor:* #stats.armor\
      #text(fill:red)[*HULL*]\
      #h(1em);*HP:* #stats.hp\
      #h(1em);*Repair Cap:* #stats.repcap\
      #text(fill:red)[*AGILITY*]\
      #h(1em);*Evasion:* #stats.evasion\
      #h(1em);*Speed:* #stats.speed
      #colbreak()
      *Save Target:* #stats.save\
      *Sensors:* #stats.sensor_range\
      #text(fill:red)[*SYSTEMS*]\
      #h(1em);*E-Defense:* #stats.edef\
      #h(1em);*Tech Attack:* #stats.tech_attack\
      #h(1em);*SP:* #stats.sp\
      #text(fill:red)[*ENGINEERING*]\
      #h(1em);*Heat Cap:* #stats.heatcap
    ]
  }

  pagebreak(weak: true)
  
  let lbl = label("topofbox_"+frame.name)

  let f = figure(placement:top,scope:"parent",
  [
    #context {
      place(center+top, dy:5.5in - measure(background).height/2, float:false, background)
    }
    #place(top+left, dx:-0.5in, float:false, text(size:50pt,fill:red)[
      #Util-size2char(frame.stats.size)
      #v(-1.4em)
      #for role in frame.mechtype {
        CC.at(role);linebreak()
        v(-1.4em)
      }
    ])
    #align(center)[
      #box(width:90%, [
        #hide([=== #text(fill:red,upper(frame.name))])
        #text(size:30pt, fill:red)[
          #frame.source\
          *#upper(frame.name)* #if(frame.at("variant",default:none) != none) {[*(#frame.variant Alt)*]}
        ]\ 
        #text(fill:red,font:"Ubuntu Mono", [#v(-0.5em) #frame.mechtype.join("/")])
        #v(-1em)
        #align(left,text(font: "Ubuntu Mono",NoKeyword([
          #set par(spacing:1.2em)
          #show regex("(<br>)+"): [#linebreak()#linebreak()]
          #frame.description
          ])))
      ])
    ]
    #hide(line(length: 100%))
    #v(-1.5em)
    #context {
      let pos = query(lbl).first().location().position()
      place(top+left, float:false, dx:-12pt, dy:pos.y -0.6in, 
        box(stroke:red+2pt, width:100%+24pt, height:100% -pos.y+0.65in+2pt,inset:4pt, 
          box(stroke:red+2pt, width:100%, height:100%, inset:8pt)[
            #place(top+center, float:false, line(length:100%, angle:90deg, stroke:red+2pt))
          ]
        )
      )
    }
  ])
  f //Place it immediately

  [#metadata("Top of "+frame.name) #lbl]
  let content_array = ()
  content_array.push(block(sticky:true,[#text(size:18pt)[*CORE STATS*]]))
  content_array.push(StatBlock(frame.stats))

  if(traits_blocks.len() > 0){
    content_array.push(block(sticky:true,[#v(1em) #text(size:14pt)[*TRAITS*]]))
    content_array += traits_blocks
  }

  content_array += PlaceMounts(frame.mounts)

  let possible_colbreak_idx = content_array.len()

  content_array += CoreSystemManual(core_system.name, core_system.at("description",default:none), core_system.blocks)

  PlaceBlocks(frame, content_array, possible_colbreak_idx, f)
}

#let FrameAutomatic(lcp, frame, background:none) = {
  let frame = PickFrame(lcp, frame)
  let trait_blocks = ParseTraits(frame.traits)
  frame.core_system.blocks = CoreSystemParsing(lcp, frame.core_system)

  PlaceFrame(frame, trait_blocks, frame.mounts, frame.core_system, background:background)
}

#let LicenseHeader(level, names) = {
  let clr = none
  let num = ""
  if(level == 1){
    clr = lightestred
    num = "I"
  } else if (level == 2){
    clr = deepred
    num = "II"
  } else {
    clr = darkerred
    num = "III"
  }
  names = names.join(", ")
  box(fill:clr, width:100%, inset:0.1em, outset:0.5em, text(fill:white, hyphenate: false,NoKeyword(upper(strong([
  #context layout(sz=> if(measure(names).width < sz.width){
    [LICENSE #num: #linebreak()#names]
   }else {
    [LICENSE #num: #names]
   })
   ])))))
}

#let LicenseFull(level, header_names, blocks) = {
  colbreak(weak:true)
  LicenseHeader(level, header_names)
  for b in blocks{
    block(b)
  }
}

#let LicenseAutomatic(lcp, license, level) = {
  let names = ()
  let blocks = ()
  if(level == 2){
    names.push(license + " FRAME")
  }
  for s in lcp.systems.filter(sys => {upper(sys.at("license",default:"")) == license and sys.at("license_level", default:0) == level}) {
    names.push(s.name)
    blocks.push(ParseSystem(lcp, s))
  }
  for m in lcp.mods.filter(mod => {upper(mod.at("license",default:"")) == license and mod.at("license_level", default:0) == level}) {
    names.push(m.name)
    blocks.push(ParseMod(lcp, m))
  }
  for w in lcp.weapons.filter(weap => {upper(weap.at("license",default:"")) == license and weap.at("license_level", default:0) == level}) {
    names.push(w.name)
    blocks.push(ParseWeapon(lcp, w))
  }
  LicenseFull(level, names, blocks)
}