#import "FieldGuide.typ": *


#let ImportLCP(folder, actions:false, backgrounds:false, core_bonuses:false, environments:false, frames:false, manufacturers:false, mods:false, npc_classes:false, npc_features: false, npc_templates:false, system_mods:false, pilot_gear:false, reserves:false, sitreps:false, skills:false, statuses:false, systems:false, tags:false, talents:false, weapons:false) = {
  let args = arguments(actions:actions, backgrounds:backgrounds, core_bonuses:core_bonuses, environments:environments, frames:frames, manufacturers:manufacturers, mods:mods, npc_classes:npc_classes, npc_features: npc_features, npc_templates:npc_templates, system_mods:system_mods, pilot_gear:pilot_gear, reserves:reserves, sitreps:sitreps, skills:skills, statuses:statuses, systems:systems, tags:tags, talents:talents, weapons:weapons)
  let lcp = (:)
  lcp.manifest = json(folder+"/lcp_manifest.json")
  for (name,arg) in args.named() {
    if(arg){
      lcp.insert(name, json(folder+"/"+name+".json"))
    } else {
      lcp.insert(name, ())
    }
  }
  let tags = json("Core/tags.json")
  for t in tags {
    lcp.tags.push(t)
  }
  lcp
}


#let title = "Field Guide to Field Guides"
#let author = "Tetragramm"

#show: Lancer.with(
  Title: title,
  Author: author,
  CoverImg: image("images/Omision of Terror Cover Final.jpg"),
  Description: "Typst Template",
  Dedication: [
    #CC.Threat, #CC.Armor, #text(font: "Ubuntu Mono")[Testing Font], 
    Look strange? You probably don't have the fonts installed.
     
    Download the fonts from #link("https://github.com/Tetragramm/flying-circus-typst-template/archive/refs/heads/Fonts.zip")[HERE].
    Install them on your computer, upload them to the Typst web-app (anywhere in the project is fine) or use the Typst
    command line option --font-path to include them.],
)

#let lcp = ImportLCP("./LCP", actions:true, backgrounds: true, core_bonuses: true, environments: true, frames: true, manufacturers: true, mods: true, pilot_gear: true, reserves: true, sitreps: true, skills: true, statuses: true, systems: true, talents: true, weapons: true)

// #let lcp = ImportLCP("./LCP-LS", core_bonuses: true, frames: true, manufacturers: true, mods: true, systems: true, weapons: true)

#Section("INTRODUCTION TO
THE FIELD GUIDE", img:stack(dir:ltr,image("2ndFleetImages/Stanford_L.jpg", width: 50%, fit: "stretch"),image("2ndFleetImages/Stanford_R.jpg", width: 50%, fit: "stretch")))

#show link: it => {
  set text(fill:blue)
  underline(it)
}

== First Questions
This document is produced using, and describes how to
use, the Lancer Field Guide package for Typst. It makes
it simple to create a document in the format of
the official Lancer content.

It's important to know that Typst is a text markup language that gets compiled to PDF, SVG, or PNG files. It's very like a programming language. However, this package, hides as much of the complexity as possible.

=== Why Typst?
First of all, Typst is free, both in the money sense, and
in the information sense. You can download it on pretty
much any computer and use it.

Second, unlike LaTeX, Typst is modern, and very easy to use. Where LaTeX is 40 years old, and it shows, Typst is much newer, and based on a much more modern understanding of programming languages.  It has native understanding of things like numbers, and json files, which allows some features that the LaTeX template doesn't have, such as parsing LCP files directly into the document. It is also faster. Much faster.

Typst is capable of doing amazing things when formatting
text. You'll see some of that below. I hope this template will be useful to
you and help you make better Lancer content, without
worrying about graphic design.

=== First Steps
There are two ways of using typst: Building it yourself or
using the web service. The web-service can be found at #link("https://typst.app").
The instructions to install it on your computer can be found at #link("https://github.com/typst/typst?tab=readme-ov-file#installation")

Either way, you need to download the template files from the itch.io page, and //TODO:Link here
make sure that the file ``` Field Guide to Field Guides.typ``` compiles properly. Online you copy all the files, images, and fonts into the workspace, and open up the ".typ" file. You'll notice the title page has several fonts used in the sample file so you can verify that it's working. Local users will need to either install the fonts, or use the ```--font-path``` CLI variable, then run ```typ typst compile 'Field Guide to Field Guides.typ'``` or ```typ typst watch ...``` if you want it to re-compile every time you save changes.

=== ABOUT THE TEMPLATE
The template is in two parts. Most important is the file
```FieldGuide.typ```, which defines a lot of useful commands,
symbols, and formatting. Second is the file ```Main.typ```,
which sets up the skeleton that you will be filling out.
Here is the full text of Main.typ, and we'll use this to explain what it does, then we'll get into what ```FieldGuide.typ``` provides.

```typ
#import "FieldGuide.typ": *
#show: Lancer.with(
  Title: "My Title",
  Author: "My Name",
  CoverImg: none,//image("images/Cover.jpg"),
  Description: "Field Guide to My Thing",
  Dedication: [],
)

//Your stuff goes here
```

That's it! Set your title, author name (or names), a description, and a dedication, all of which get placed onto the title page, and into the PDF metadata as appropriate.  Then you can start adding content below.



You are a lancer, an exceptional mech pilot among
already exceptional peers, and you live in a time
where the future hangs as a spinning coin at the apex
of its toss – the fall is coming, and how the coin lands
is yet to be determined.

Far now from our humble beginnings, humanity has
spread out among and between the stars for thou‐
sands of years. We have set empty worlds and barren
moons alight with civilization, tamed asteroids and gas
giants – even built lives in the hard vacuum of space
itself. We have taken root in our arm of the Milky Way;
life – in its infinite diversity – thrives and expands.

For some, life in this time is as a river – forever moving,
with the land and time of their birth left somewhere far
behind. For most, life is spent on their home world, moon,
or station, linked to the rest of humanity via fantastic tech‐
nologies, or isolated to the politics, stories, and histories
of their own lands. The trillions that make up humanity
live, for the most part, as you or I do now.

But wonders tie the galaxy together in this age.

Connecting all worlds is blinkspace – an unknowably
vast and strange plane parallel to the one in which we
live, pierced by blink gates that allow us to travel with
speed and safety. Thanks to these massive, star-
bound doors, every corner of space is open to the
daring. These portals are common wonders: thou‐
sands of ships travel through them every day seeking
trade, migration, travel, war, and myriad other aims.

Filling the lonely void is the omninet, a data-sharing
network built off the blink that connects every computer,
every server – everything – to everything else. The
omninet is much more than a way to send messages or
a means for people on far-flung worlds to read the
galaxy’s news; it overlays all human communications,
facilitating government, industry, culture, and realms
more esoteric still. Data is the new wealth, and the
omninet means that all wealth can be shared.

The form of that wealth is manna. Uniting the disparate
nations of the human diaspora outside the Core,
manna is the universal currency accepted by every
market on every planet. When a galaxy’s wealth of raw
resources are available for exploitation, a community’s
wealth comes from both its past and its potential.

The vast mass of humanity is administered by a
single sprawling government: Union, the galactic
hegemony. Luna and Mars, Mercury and Venus.
Saturn, Jupiter, Neptune, and Uranus. Phobos and
Deimos. Io, Europa, Ganymede, and Callisto. Titan
and Enceladus. These worlds strung in their orbit
around Sol are the diadem atop which Cradle rests,
the seat of Union’s power and humanity’s ancient
heart. From Cradle, Union controls the three levers
of the galaxy: the blink gates, the omninet, and
manna. Without these levers, and without Union, the
galaxy would fall into chaos.

Union is a new kind of utopia. A new state –
communal and post-capital – for a New Humanity.
Union was born from the ashes and ice of the Fall:
the collapse that felled Old Humanity, boiling Cradle
and withering her colonies entirely. Though it has
been thousands of years since Union was founded –
and thousands more since the Fall – New Humanity
knows
only
one
truth
among
ten
thousand
unknowns: if we are to survive, then we must come
together in solidarity and mutual aid.

Despite
Union’s
conviction
–
and
despite
its
successes so far – the sheer size of this collective
project is daunting. Union is distant to most people:
fictionalized in omninet dramas and novels; dreamed
about by children and wanderers; hailed as the
promised kingdom or damned as the pit by religions
across the galaxy. For all its authority, Union prefers to
rule from a distance. Few have ever seen one of
Union’s administrators, let alone suffered one of its
naval campaigns. For those who have never seen its
flag, Union is all but a myth; for those whose skies
have been darkened by Union’s ships, the hegemony
may have brought liberty – but it brought death first.

The galaxy remains a dangerous place outside the
Core. Rebellions, insurrections, piracy, wars – civil
and interplanetary – continue to flare and burn their
way through space, though only the most desperate
conflicts
require
Union’s
intervention.
Disputes
between Union’s subject states are common enough
that there is still a need for militaries, militias, and
mercenaries. Five major suppliers offer arms and
armor to states and entities outside the Core that
desire them. These manufacturers exist in delicate
balance
with
Union:
though
the
administrators
regulate and the suppliers comply, these two philo‐
sophies – one of post-capital utopia and the other of
permanent and wild growth – rush toward an irrecon‐
cilable end.

You are one person, alive in this time of tumult and
peace – a time of promise that was built on the sacri‐
fice of those who came before and is threatened still
by the heirs of old adversaries. You are one whose life
is lived in the great river, where lives cross stars and
time; where one person in the right place at the right
time can divert the course of history; where the
collective action of comrades can save worlds, lives,
and better define Union’s utopian dream.

You are a mech pilot – one of the best, a lancer – and
yours is the story of this spinning coin at the apex of
its toss. At this pivotal moment in history, what will
you and your comrades do when fate, foresight, and
luck – good or bad – puts you in the right place at the
right time?

On which side will you fall?

=== The Cavalry
Your character in the world of _Lancer_ is a mechanized
cavalry pilot of particular note – a lancer. Whatever
the mission, whatever the terrain, whatever the
enemy, your character is the one who is called in to
break the siege or hold the line. When the drop
klaxons sound, it’s up to them to save the day.

Your lancer hails from a world and culture of your
choice, but is human. They might come from Earth –
or Cradle, as it is now called – but to hail from Earth
in the age of Union is exceedingly rare. No, it is far
more likely that your pilot hails from somewhere in
the vastness of the human diaspora. In Lancer, it has
been millennia since we left Earth, and most of
humanity lives among the stars in our arm of the
Milky Way.

This
humanity
is
familiar
and
strange
in
equal
measure. As far as we know, the only sentient,
sapient beings in our stellar neighborhood are other
humans, but don’t take this as a limitation – there are
many roads to becoming a lancer. Your character
might be the product of significant technological and
capital investment on the part of their employers; or,
they could be a born prodigy – a wunderkind who
commands a mech with innate grace and ability,
perhaps discovered by a secretive recruiter. Your
character might be a lucky conscript – a battle-proven
draftee who managed to survive their first drop,
promoted by desperate commanders looking for a
hero. They could also be the scion of an ancient,
atemporal monarchy, destined to inherit the chassis
of their polypatriarch. Your character could be a jaded
volunteer from a Union liberator team, motivated by a
closely-guarded ember of hope for a better future; or
an anointed Loyal Wing of the Albatross; or a
facsimile of a long-dead pilot, grown in batches of
thousands; a spacer who has spent too long listening
to the deep whispers of the void.

Whatever led your character to the cockpit of their
mech, they are the sum of many parts: enhanced
through a combination of training, natural skill, battle‐
field
experience,
and
neural
or
physical
augmentation, a lancer is the equivalent of a knight of
old, a flying ace, or another class of elite warrior.

Lancers, many proudly declare, are a cut above
other pilots.

They aren’t entirely wrong. The recruitment, training,
and maintenance of a mech pilot demand the invest‐
ment of much more time and capital than your
average soldier. To operate a mech at peak efficiency,
a pilot needs extensive physical and mental training,
or advanced (and expensive) physiological and onto‐
logical augmentations. Washout and injury rates are
high thanks to the demanding training process, but a
high bar is necessary: once a candidate attains their
final certifications and ships out to their first posting,
they face only the most dangerous missions. Mechs
aren’t sent in to keep the peace – they’re sent in when
all other options have failed. Your character, a lancer,
represents the best of this exceptional corps.

Remember, whatever their history, your pilot is ulti‐
mately human. They’re just as flawed as the rest of
us, just as perfect. Pilots are heroes and villains;
brave souls and cowards; lovers and fighters, all.
Some of them stand strong when everyone else runs,
or are the first to face danger – our best and brightest.
But they, too, break under the pressure; they fail; they
kill, even when they could have spared a life.

Pilots and lancers are from all walks of life. Every
station, criminal history, and economic class is
represented in their ranks.

== Playing Lancer
Your character in _Lancer_ is, first and foremost, a pilot – a
dynamic, larger than life presence on and off the battle‐
field who inspires and terrifies in equal measure – but
your character also has a second component: your
mech. Though you can define their identities separately,
pilot and mech are two parts of the same whole.

The first section of this book (p. 16) talks you through
*Building Pilots and Mechs*.

The
second
section,
*Missions,
Uptime
and
Downtime* (p. 38), is about narrative play, choosing
missions, and playing during downtime.

The third section, *Mech Combat* (p. 56), is about
fighting in and with mechs.

The fourth section is the *Compendium* (p. 86), in
which all character options can be found.

The fifth section is the *Game Master’s Guide* (p.
254), which offers advice for tweaking rules, creating
non-player characters (NPCs), and running missions.

The sixth and final section is the *Setting Guide*
(p. 334), an in-depth reference on the canon setting.

=== What You Need
This game uses two sorts of dice: twenty-sided dice
(*d20*) and six-sided dice (*d6*). You’ll roll these dice to
determine the outcome of uncertain situations, such
as firing a weapon, hacking a computer, or climbing a
sheer cliff face. When the rules call for you to make a
roll, it will also tell you how many dice to roll. For
example, *1d20* means you need to roll a single *d20*,
whereas *2d6* means you need to roll two *d6s*.

Sometimes the rules will call for you to roll *1d3*. That’s
just a shorthand way of saying you should roll *1d6
and halve the results* (rounded up). When you’re
called on to roll *1d3*, a result of 1 or 2 on a *d6* equals
1, 3 or 4 equals 2, and 5 or 6 equals 3.

_Lancer_ is best played with 3-6 players, but can be
played with as little as two or as many as you feel
comfortable with. Each player needs at least one *d20,
a number of d6s, and some paper or a character
sheet* to write down information. If you’re playing
online, or welcome computers at the table, the #Keyword()[Comp/
Con character building tool] is recommended.

This game makes use of grid-based tactical combat, so
it can be helpful to have paper with square or hexagonal
grids, such as graph paper or pre-prepared battle maps.
Miniatures aren’t necessary to play this game but they
can sometimes make combat easier to visualize.

Most of the players take on the role of pilots - these
are the player characters, or *PCs* - but one player is
the *Game Master*, or *GM*. The GM acts as a narrative
guide, facilitator, and the arbitrator of the game’s
rules. They help create the story and narrative your
group will explore and portray all of the NPCs. For
more information on the GM role and a list of rules,
tips, and tools for GMs to use, refer to the *Game
Master’s Guide* on p. 254.

Finally, we recommend that all players download our
free companion app, #Keyword()[Comp/Con]; it isn’t necessary to
have the app to play the game, but it can make it
more accessible to players who aren’t able or don’t
wish to thumb through this book.

=== The Golden Rules
There are two golden rules to remember when playing
_Lancer_:

*I: Specific rules override general statements and rules.*

_For example, when you shoot at an enemy, your roll is
normally influenced by whether they’re in cover;
however, Seeking weapons ignore cover. Because the
Seeking tag is a specific rule, it supersedes the
general rules governing cover._

*II: Always round up (to the nearest whole number).*

=== Narrative Play and Mech Combat
_Lancer_
makes
a
distinction
between
freeform
*narrative play* and *mech combat*, in which tracking
individual turns and actions is important.

During narrative play, players act naturally and spon‐
taneously as needed. Time might pass more quickly,
scenes might be shorter, and individual rolls might
count for more or less. Most of your game’s story and
interaction between characters will take place during
narrative play. In mech combat, players act on their
turn and are restricted in what they can do and how
often, making each action much more impactful and
tactical.
Swapping
between
mech
combat
and
narrative play is fairly natural, especially if you’ve
played other games with turn-based combat.

The reason there are two types of play is that they
represent different approaches to storytelling in role‐
playing games. One, narrative play, is focused on the
story and characters, with a rules-light approach to
conflict resolution; the other, mech combat, relies
more on rules and tactics, like a board game.
Depending on your GM and group of players, you
could spend a whole session in one type of play or
the other, or with some of both.

Neither of these is the “correct” way to play the game.
Groups will find a balance between the two that
works for them. _Lancer_ provides rules for both so that
both people who like to explore stories or who enjoy
tactical combat will have an enjoyable experience.

=== Skill Checks, Attacks, and Saves
There are three types of dice rolls in Lancer: *skill
checks*, *attacks*, and *saves*.

In narrative play, you will only need to worry about the
first of these. In mech combat you will use all three.

You make *skill checks* when your character is in a
challenging or tense situation that requires effort to
overcome. When you want to act in such a situation,
state your objective (e.g., break down the door,
decrypt the data, or sweet-talk the guard), then roll
*1d20*, and add any relevant bonuses. On a total of
*10+*, you succeed. A result of *9 or less* means you
failed to accomplish your goal and may suffer
consequences as a result. Although the GM can’t
change the target number (*10*), they have access to
several tools that are explained later (p. 45-47), such
as declaring a skill challenge or deciding that your
action is #Keyword()[Difficult] or #Keyword()[Risky].

In mech combat, *attacks* are any offensive actions
against other characters, like firing a weapon or
hacking into an opponent’s mech. Attack rolls are
similar to skill checks – you roll *1d20* and add any
bonuses – but the target number isn’t always *10*, and
usually depends on the defensive capabilities of your
target. For an attack to be successful it needs to
equal or exceed the target’s defense. Successful
attacks are described as “*hits*” - so if the rules tell you
that an effect happens “*on hit*”, that means it takes
place when you make a successful attack. Some
attacks also result in *critical hits*. On a roll of *20+* you
perform a critical hit, which allows you to deal more
damage or sometimes trigger extra effects.

Although there are different types of attacks, including
ranged, melee, and tech attacks, they all use the
same basic rules described here.

Lastly, *saves* are rolls made to avoid or resist
negative effects in mech combat. You might roll a
save to prevent a hacker wrecking your systems, to
avoid being blinded by a flash grenade, or to dive
away from an explosion. To save, you roll *1d20* and
add any bonuses, but the target number can differ
from *10* as it can with attacks. The target number for a
save usually depends on the abilities of the attacker. If
you equal or exceed this number, you succeed; if your
roll is lower, you fail. The outcome of each result will
depend on what you are trying to avoid.

==== Contested Checks
In some cases, the rules will tell you to make a
*contested check*, representing a challenge between
two parties. In a contested check, both participants
make skill checks and add any bonuses. Whoever
has the highest result wins. If the result is a tie, the
attacker – the one who initiated the contest – wins.

You might make contested checks in both narrative
play and mech combat.

==== Choosing to fail
You may always choose to fail a skill check or save.
You might do this if an ally is trying to help you out or
even just because you think failing would create a
more interesting story.

==== Bonuses
There are three kinds of bonuses that can be applied
to rolls in _Lancer_:
- Accuracy (Represented as #CC.Accuracy)
- Difficulty (Represented as #CC.Difficulty)
- #Keyword()[Statistic Bonuses]
Accuracy
and
Difficulty
represent
momentary
advantages or disadvantages (see below). *Statistic
bonuses* come from three sources: your pilot’s talent
and experience (*triggers*), their skill with mechs
(*mech skills*), and their Grit. Each roll can only
benefit from one statistic bonus at a time. In many
cases, none of these bonuses will apply and you will
just roll *1d20*.

==== Accuracy and Difficulty
Accuracy and Difficulty are temporary modifiers
gained and lost in rapid, chaotic moments of action.

For example, two mech pilots, equally matched, duel
amidst the shifting debris of a shattered frigate.
Attempting to land a shot, they dodge to avoid
incoming fire and floating, slagged bulkheads. The
debris makes it unlikely that either will land a clean hit;
however, one of the pilots, thinking quickly, hides
among the floating metal. When their enemy gets
close, the pilot springs forth from hiding and catches
their opponent unaware – making the shot much
easier than normal.

Situations like this can cause pilots to gain Accuracy
or Difficulty.
- Each point of Accuracy adds *1d6* to a roll.
- Each point of Difficulty subtracts *1d6* from a roll.
- Accuracy and Difficulty cancel each other out
  on a *1:1* basis.

If you are lucky enough to be rolling several of the
same bonus dice, whether Accuracy or Difficulty,
you don’t add them together to determine the result.
Instead, find the highest number rolled and apply it to
the final roll. Because of this, no roll can ever receive
more than *–6* or *+6* from Accuracy or Difficulty.

For example:
- For an attack with *2* Accuracy, roll *2d6* and
  choose the highest of the two dice, then add that
  number to your attack roll. If you roll *3* on one die
  and *4* on the other, you add *+4* to the roll, not *+7*.
- For an attack with *2* Accuracy and *1* Difficulty,
  you only add *1d6* to your attack roll as *1*
  Difficulty and *1* Accuracy cancel each other out.
- For an attack with *1* Accuracy and *1* Difficulty,
  you don’t add anything to the roll – the dice
  cancel each other out.

==== Grit
Pilots are lucky and unique individuals, multi-talented
and
resilient.
Even
so,
brand-new
pilots
don’t
measure up to tempered, battle-hardened veterans
when push comes to shove. The benefits of experi‐
ence are measured by Grit, a bonus that reflects your
pilot’s deep reservoirs of resolve and will to live.

Grit is half of your character’s license level, rounded
up. It improves attack bonuses, hit points, and save
targets for both your pilot and your mech.

=== MISSIONS, DOWNTIME, AND SCENES
Ongoing games of _Lancer_ are usually divided into
*missions*, each of which might encompass one play
session
or
several,
separated
by
periods
of
*downtime*.

Missions have specific goals or objectives that can be
completed
within
a
discrete
amount
of
time:
destroying a building, breaking into a secure facility to
recover vital data, evacuating civilians, uncovering a
conspiracy, or holding the line against enemy attack,
for example. Missions also provide some preparation
time in which you can establish goals, stakes, and
equipment for your characters.

If your character isn’t on a mission, you’re in
*downtime*. This is the narrative space between
missions,
in
which
moment-to-moment
action
doesn’t matter as much and roleplaying matters
much more. During downtime you can progress
plots, projects, or personal stories, moving the clock
forward as much or as little as you want. Days,
months, and even years can pass in downtime,
depending on the pace of your game.

In both missions and downtime, play is divided into
*scenes*. A scene is a period of continuous dialogue,
action, or activity that has a discrete starting and
stopping point. This is called a scene because it’s
helpful to think about it in cinematic terms: as long as
the focus (or ‘camera’) is on the players and their
action, a scene is happening. When the focus cuts
away from the current scene, or the current action
naturally ends, that’s when the scene should end too.

A single combat encounter or a dialogue between
characters are both great examples of scenes, but a
scene can also be something like a montage.

It’s important to pay attention to the beginning and
end of scenes, as many special character and mech
abilities end or reset at the end of a scene.

#FullPageImageFramed(image("images/FullPageImg.png", fit:"stretch", width:100%))

#FullPageImage(image("images/JWST-Jupiter.png"))

== Chap 1

#figure(placement:top, scope: "parent", 
LancerTable(title:"Level Chart", instructions: "",
  columns:(auto, auto, 2fr, 1fr, 1fr, 1fr, 2fr), 
  table.vline(x:2, stroke:white+3pt),
  LancerHeaderCell()[LL],
  LancerHeaderCell()[Grit],
  LancerHeaderCell()[Total Mech Skill Points (+6 MAX)],
  LancerHeaderCell()[TOTAL LICENSE RANKS],
  LancerHeaderCell()[TOTAL TALENT RANKS],
  LancerHeaderCell()[TOTAL CORE BONUSES],
  LancerHeaderCell()[TOTAL PILOT TRIGGER POINTS (+6 MAX)],
  [*0*], [0], [2], [0], [3], [0], [8],
  [*1*], [1], [3], [1], [4], [0], [10],
  [*2*], [1], [4], [2], [5], [0], [12],
  [*3*], [2], [5], [3], [6], [1], [14],
  [*4*], [2], [6], [4], [7], [1], [16],
  [*5*], [3], [7], [5], [8], [1], [18],
  [*6*], [3], [8], [6], [9], [2], [20],
  [*7*], [4], [9], [7], [10], [2], [22],
  [*8*], [4], [10], [8], [11], [2], [24],
  [*9*], [5], [11], [9], [12], [3], [26],
  [*10*], [5], [12], [10], [13], [3], [28],
  [*11*], [6], [13], [11], [14], [3], [30],
  [*12*], [6], [14], [12], [15], [4], [32],
  )
)

#LancerTable(title:"Backgrounds", instructions: "Roll 1d20", columns:(auto, 1fr), fill_function: calc.odd,
[*0*],  [Celebrity],
      [*1*],  [Celebrity],
      [*2*],  [Celebrity],
      [*3*],  [Celebrity],
      [*4*],  [Celebrity],
      [*5*],  [Celebrity],
      [*6*],  [Celebrity],
      [*7*],  [Celebrity],
      [*8*],  [Celebrity],
      [*9*],  [Celebrity],
      [*10*], [Celebrity],
      [*11*], [Celebrity],
      [*12*], [Celebrity],)

#LoreBox()[
  DIASPORANS\
To be a Diasporan is to be a member of the
largest class of humanity: world-bound people
outside of the Galactic Core, who identify with
single homeworlds they may never leave. Dias‐
porans make up the vast bulk of the human
population, settled and left to develop on their
own during the First and Second Expansion
Periods. The Diaspora includes everyone from
the people of worlds proximal to the Core
through to worlds that have lived without – or
have never known – Union’s presence for thousands of years, and all other societies in
between. Diasporan worlds can be covered in
glittering
or
stinking
metroswathes,
mixed
urban
spaces,
quiet
ecological
preserves,
arcadian paradises, or lonely terrestrial barrens
– any places humans or groups of humans can
live. For better or for worse, the Diaspora is
what people see when they think of “humanity”.
]


#TechBox(title:[Invade], body:[
  When you Invade, you mount a direct electronic
attack against a target. To Invade, make a tech attack
against a character within Sensors and line of sight.
On a success, your target takes 2#CC.Heat and you
choose one of the Invasion options available to you.
Fragment Signal is available to all characters, and
additional options are granted by certain systems
and equipment with the Invade tag.\
#box(width:100%,fill:white, outset:(x: 0.5em), inset:(y:0.65em), stroke:(y:narrativepurple),[
  Fragment Signal. You feed false information,
obscene messages, or phantom signals to your
target’s computing core. They become Impaired and
Slowed until the end of their next turn.
])
You can also Invade willing allied characters to
create certain effects. If your target is willing and
allied, you are automatically successful, it doesn’t
count as an attack, and your target doesn’t take
any heat.
])

#WeaponBox(
title:[Leviathan Heavy Assault Cannon], title_tech:[Superheavy Cannon\
[#CC.Range;8][1d6#CC.Kinetic]], body:[
Unlike other Superheavy weapons, the Leviathan
can be used with Skirmish.

You can spin up this weapon’s barrels as a quick
action. While spinning, it gains Reliable 5 and
2#CC.Heat;(SELF), and its damage increases to 4d6+4#CC.Kinetic;
however, you become Slowed and can no longer
use the Leviathan with Skirmish.
You can cease this effect as a Protocol.],
flavor_text:[
The Leviathan Heavy Assault Cannon (HAC)
is a massive, multi-barrel rotary cannon
fed by an external reservoir, usually
dorsally mounted on the chassis carrying
it. Unmodified, the Leviathan should only
be fired within the recommended burst
timing specifications to prevent
percussive trauma to joints and pilots.

In partnership with Harrison Armory’s
Think Tank, IPS-N is currently
investigating remote solutions for the
cannon’s ammunition consumption demands.
])


#ProtocolBox(
title:[Neural Shunt], title_tech:[Active (1CP), Protocol],
flavor_text:[
The Leviathan Heavy Assault Cannon (HAC)
is a massive, multi-barrel rotary cannon
fed by an external reservoir, usually
dorsally mounted on the chassis carrying
it. 
])

#ActionBox(
title:[Mark for Death], title_tech:[Full Action],
flavor_text:[
The Leviathan Heavy Assault Cannon (HAC)
is a massive, multi-barrel rotary cannon
fed by an external reservoir, usually
dorsally mounted on the chassis carrying
it. 
])

#ReactionBox(title:[Exposed Singularity], title_tech:[Reaction, 1/round],
trigger:[Your mech takes damage.], body:[You may immediately *teleport* to a free
space within *1d6 spaces*.]
)

#GearBox(title:"Personal Drone", title_tech:"Gear", flavor_text:[
  A collar-like device that fits snugly around its wearer’s
neck, projecting a holographic image over their face
and head. Prosocollars can change their wearer’s
voice and scramble or change their appearance. The
projection won’t stand up to close inspection, but it
can
easily
fool
electronic
systems
and
distant
observers.
])

#RedBox(title:[Hull])[
  Roll Hull when: smashing through or pulverizing
obstacles, vehicles, or buildings; lifting, dragging,
pushing, or hurling an enormous amount of weight;
grabbing or wrestling mechs, starships, or mech-
sized creatures; resisting a huge amount of force;
or, staying upright in cataclysmic weather.
]

*Name what you want.* You can *definitely* get it, but
depending on the outlandishness of the request, the
GM chooses one or two:
- It’s going to take a lot more time than you thought.
- It’s going to be really damn risky.
- You’ll have to have to give something up or leave something behind (e.g., wealth, resources, allies).
- You’re going to piss off someone or something important and powerful.
- Things are going to go wildly off-plan.
- You’ll need more information to proceed safely.
- It’s going to fall apart damn soon.
- You’ll need more resources, but you know where to find them.
- You can get something almost right: a lesser version, or less of it.

#ContentBox(clr:red, clip:"top-right", txt:[
  Any line from the Blackbeard (B) to the Lancaster
(L)
would
cross
the
white
line
marking
out
the
Lancaster’s point of contact with the cover, so the
Lancaster gets full hard cover bonus against the
Blackbeard’s attacks. That’s not true for the Genghis
(G)’s position, so the Genghis is flanking the Lancaster.
])

== Manual vs Automagic
The template is capable of reading an LCP and formatting it appropriately.  But you may not want to do that.

For example, below is the Ace talent, formatted as it is in the core book.  To the right, is the automatically parsed LCP file.  As you can see, there are two additional boxes, and it takes up much more space.  The LCP, while convenient, is difficult to parse properly. 


#PlaceTalent((name:"Ace", description:[Every pilot brags about their abilities; occasionally,
some even have the reputation to back it up. Harmonious Domesticity is one of these pilots. As an ace, they
aren’t just ranked among the most qualified of
pilots – they’re among the most qualified of lancers.

Whether you’re a talented rookie or a grizzled veteran,
you’re one of these aces. Your skills as a pilot are
notorious enough that your callsign is known throughout the system.],
ranks: (
  (name:"Acrobatics", description:[
    While *flying*, you get the following benefits:
    - You make all Agility checks and saves with *+1* Accuracy.
    - Any time an attack misses you, you may fly up to
      *2 spaces* in any direction as a *reaction*
    ]),
  (name: "Afterburners", description:[
When you Boost while flying, you may move an additional *1d6 spaces*, but take *heat equal to half that
amount.*]),
(name: "Supersonic", description:[
As a *quick action* on your turn, you may spin up your
thrusters. If you end your turn *flying*, you may
nominate a character within a Range equal to your
Speed and line of sight, and gain this reaction:
#ReactionBox(title:"Supersonic", title_tech: "Reaction, 1/round", trigger:"Your target's turn ends.", body:"You fly to a space free and adjacent to them. There must be a path to do so but you can move even if the nominated character is no longer within your movement range or line of sight. This ignores engagement and does not provoke reactions.")])
))
)

#PlaceTalent(ParseTalent(lcp, "Ace")) 

Talents are fairly simple.
- Automagic is ```typ #PlaceTalent(ParseTalent(lcp, "Ace")) ```


== Woo!
#lorem(100)

#lorem(100)

#lorem(100)

#figure(placement:bottom, scope: "parent", image("images/BottomHalf.png"))

#lorem(100)

#lorem(100)

#lorem(100)

#lorem(100)

#FullColImage(image("images/FullCol.png"))

#FullColImage(image("images/FullCol.png"))

#lorem(100)

== IPS-Northstar
#for f in lcp.frames {
  if (f.source == "IPS-N"){
    FrameAutomatic(lcp, f.name, background:image(width:7in, "images/IPS-N-Background.png"))
    LicenseAutomatic(lcp, upper(f.name), 1)
    LicenseAutomatic(lcp, upper(f.name), 2)
    LicenseAutomatic(lcp, upper(f.name), 3)
  }
}
== Smith-Shimano Corpro
#for f in lcp.frames {
  if (f.source == "SSC"){
    FrameAutomatic(lcp, f.name, background:image(width:7in, "images/SSC-Background.png"))
    LicenseAutomatic(lcp, upper(f.name), 1)
    LicenseAutomatic(lcp, upper(f.name), 2)
    LicenseAutomatic(lcp, upper(f.name), 3)
  }
}
== HORUS
#for f in lcp.frames {
  if (f.source == "HORUS"){
    FrameAutomatic(lcp, f.name, background:image(width:7in, "images/Horus-Background.png"))
    LicenseAutomatic(lcp, upper(f.name), 1)
    LicenseAutomatic(lcp, upper(f.name), 2)
    LicenseAutomatic(lcp, upper(f.name), 3)
  }
}
== Harrison Armoury
#for f in lcp.frames {
  if (f.source == "HA"){
    FrameAutomatic(lcp, f.name, background:image(width:7in, "images/HA-Background.png"))
    LicenseAutomatic(lcp, upper(f.name), 1)
    LicenseAutomatic(lcp, upper(f.name), 2)
    LicenseAutomatic(lcp, upper(f.name), 3)
  }
}

// #FramePage(lcp, "Pegasus", none)

// Command             10pt    11pt    12pt
// \tiny               5       6       6
// \scriptsize         7       8       8
// \footnotesize       8       9       10
// \small              9       10      10.95
// \normalsize         10      10.95   12
// \large              12      12      14.4
// \Large              14.4    14.4    17.28
// \LARGE              17.28   17.28   20.74
// \huge               20.74   20.74   24.88
// \Huge               24.88   24.88   24.88
// 
// 