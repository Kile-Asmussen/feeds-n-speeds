
#set scale(reflow: true)

#let relative(..points) = {
  points = points.pos()
  let curr = points.at(0)
  let res = (curr,)
  for next in points.slice(1) {
    curr = (curr.at(0) + next.at(0), curr.at(1) + next.at(1))
    res.push(curr)
  }
  return res
}

#let box-it(ct) = box(
  width: 64pt,
  height: 64pt,
  stroke: none,
  align(center + horizon, ct) + place(center + horizon, box(width: 64pt, height: 64pt, [])),
)

#let letter(x: 100%, y: 100%, dx: 0% + 0pt, dy: 0% + 0pt, fill: white, c) = {
  box-it(place(
    dx: dx,
    dy: dy,
    center + horizon,
    scale(
      origin: center + horizon,
      x: x,
      y: y,
      text(font: "Bungee", size: 85pt, fill: fill)[#c],
    ),
  ))
}

#let symbol(con) = box-it(con)

#let sym-cog(tooth-displacement: 20pt, tooth-size: 10pt, thickness: 10pt, radius: 15pt) = {
  let tooth(angle) = place(
    dy: calc.cos(angle) * -tooth-displacement,
    dx: calc.sin(angle) * tooth-displacement,
    center + horizon,
    rotate(
      angle,
      square(
        fill: white,
        size: tooth-size,
        radius: 2pt,
      ),
    ),
  )
  symbol(
    circle(stroke: color.white + thickness, radius: radius)
      + (0deg, 45deg, 90deg, 135deg, 180deg, 225deg, 270deg, 315deg).map(tooth).sum(),
  )
}

#let arrow(angle) = symbol(
  rotate(angle, polygon(
    fill: white,
    stroke: stroke(paint: white, thickness: 4pt, join: "round"),
    ..relative(
      (20pt, 0pt),
      (20pt, 20pt),
      (-14.5pt, 0pt),
      (0pt, 30pt),
      (-11pt, 0pt),
      (0pt, -30pt),
      (-14.5pt, 0pt),
    ),
  )),
)

#let keymap(arr: (), dict: (:), chars: "", map) = {
  let res = (:)
  for x in arr {
    res.insert(x, map(x))
  }
  for c in chars.codepoints() {
    res.insert(c, map(c))
  }
  for (k, v) in dict {
    res.insert(k, map(v))
  }
  res
}


#let plates = (:)

#{
  plates.alphabet = (
    ..keymap(chars: "ABCDEFGHIJKLMNOP" + "RSTUVWXYZ", letter.with(y: 90%)),
    "Q": letter(y: 80%, dy: -3pt, "Q"),
  )

  plates.numbers = (
    "0": box-it(
      letter(y: 90%, "0")
        + place(center + horizon, scale(x: -100%, line(angle: 45deg, stroke: 10pt + white, length: 40pt))),
    ),
    ..keymap(chars: "123456789", letter.with(y: 90%)),
  )

  plates.ascii-symbols = (
    ..keymap(chars: "!\"#$" + "&'()*+," + "./:;<=>?@[\\]^" + "{|}", letter.with(x: 75%, y: 75%)),
    "%": letter(x: 70%, y: 70%, "%"),
    "_": letter(x: 100%, y: 70%, "_"),
    "-": letter(x: 150%, y: 70%, "-"),
    "`": letter(x: 70%, y: 100%, dy: 25pt, "`"),
    "~": letter(x: 80%, y: 100%, "~"),
  )

  plates.extra-symbols = (
    ..keymap(
      dict: (
        "times": sym.times,
        "ldq": sym.quote.l.double,
        "rdq": sym.quote.r.double,
        "lq": sym.quote.l.single,
        "rq": sym.quote.r.single,
      ),
      letter.with(x: 75%, y: 75%),
    ),
    circ: symbol(circle(fill: white, radius: 25pt)),
    ring: symbol(circle(stroke: 10pt + white, radius: 20pt)),
    cog: sym-cog(),
    sq: symbol(square(fill: white, size: 48pt, radius: 5pt)),
    blank: symbol(square(fill: white, size: 35pt, radius: 5pt)),
    start: symbol(
      rect(fill: white, radius: 5pt, width: 45pt, height: 15pt)
        + scale(x: 80%, text("start", fill: white, font: "Bungee", size: 20pt)),
    ),
    select: symbol(
      rect(fill: white, radius: 5pt, width: 45pt, height: 15pt)
        + scale(x: 70%, text("select", fill: white, font: "Bungee", size: 20pt)),
    ),
  )

  plates.arrows = keymap(
    dict: (
      arr-t: 0deg,
      arr-tr: 45deg,
      arr-r: 90deg,
      arr-br: 135deg,
      arr-b: 180deg,
      arr-bl: 225deg,
      arr-l: 270deg,
      arr-tl: 315deg,
    ),
    arrow,
  )

  plates.all = plates.values().sum()
}


#set page(fill: none, height: auto, width: auto, margin: (rest: 0pt))


#if sys.inputs.at("all", default: none) != none {
  grid(
    columns: 10,
    ..plates.all.values(),
  )
} else {
  scale(
    x: 200%,
    y: 200%,
    sys
      .inputs
      .at("sym", default: "A")
      .split(regex(`\s+`.text))
      .map(k => plates.all.at(k, default: letter(fill: red, "?")))
      .join([]),
  )
}

