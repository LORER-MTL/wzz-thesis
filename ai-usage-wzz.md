Dear Members of the Jury,

The following document describes how I used modern AI tools in the work presented in my Master's thesis
on improving the canonicalization time of CVXPY. No assistance has been used to write this document.

Like I mentioned in the acknowledgements section, I have used AI tools, in particular Claude Code
from Anthropic, throughout almost all parts of the research process. Each part has greatly varying
usages, so I will detail each of them in separate sections below.

## Coding

By coding, I am referring to open source code contributions which has been (or is planning to be)
added to the CVXPY and SparseDiffEngine repositories. I consider this code of higher importance
than the ones in the experiments section below, since it can potentially affect lots of users.

For coding, I would first start with a plan of what I wanted to add and iterate with Claude
Code until I was satisfied. Then Claude Code is able to implement everything, write new tests
and verify that everything works. After that, I will make a pull request and do another
more thorough code review which may include some stylistic cleanups as well.
After iterating a few more times on cleaning up the code, one or maybe several of the
other maintainers will verify my pull request and eventually merge it.
Although Claude Code is used at basically all stages from making a plan, to writing the code
and even acting sometimes as a reviewer, I still think the process highly depends on my ideas
and vision I have for the software.

From my experience, this is more or less standard practice in software engineering these days.
I have thought a lot about AI usage in open source, and maybe it is unfortunate that it has gone
this way, but it is atleast the standard practice that the two main packages I contribute
to adopted recently.

## Experiments

In contrast to coding, I refer to experiments as more "throw-away" code that is written
to test out some ideas or improvements I have in mind. They can sometimes become more serious
and would then fall into the category of coding.

For experiments, I was a lot less severe with code quality than the section above.
The only thing I verified thoroughly is that the experiments are running the right versions
of the software and were measuring the right thing. Other than that, I left a lot of leeway
for Claude Code to generate potentially nasty and duplicated code. On that end, one
thing I am currently working on is to re-organize the experiments to only keep the final
ones that appear in the thesis. I will make sure they are reproducible, easier to read,
and of overall similar quality to the code I mention in the section above.

## Research

By research, I am referring specifically to the task of understanding other similar works
in the literature review as well as solidifying the story of the contribution.
I am proud to say the main ideas of the thesis were of my own, but a lot of
the surrounding improvements that went between an initial idea to
a completed thesis were supported with AI tools.
In terms of understanding other works, Claude Code is able to organize agents that
search for papers and documentation online, process them, and report back to me.
I then get a compressed and more directed summary of what I am looking for, which I will
of course verify on my own. I haven't blindly trusted AI tools because they can make mistakes,
but I have used it as a search aggregator, and it has been tremendously helpful in giving
me a direction to look for.

With regards to polishing the story of the contribution, I have used AI tools
as a sort of conversational companion which could verify the validity of some ideas
as well as make them more concrete. I also got lots of help from discussions with
Daniel Cederberg (the other developer of SparseDiffEngine) and Oscar Dowson
(the main developer of JuMP, which is in the literature review),
as well as feedback to ask the right questions and talk about the
right things from my advisor Prof. Antoine Lesage-Landry. 

It is hard to quantify the contribution of AI tools in this regard,
but I am confident to say a lot of the main ideas and shape of the
contribution came from our end, with AI tools helping only occasionally
to verify, solidify and question our approach.

## Writing

Finally, I have also used Claude Code for assistance in the actual prose of the thesis.
A large part of this usage came down to improving the english and phrasing of the points
I wanted to get across. The workflow would look as follows: I first wrote down some high level
ideas I wanted to include in a section or paragraph on paper, then I would try to form
coherent sentences in a very long prompt to Claude Code, which would make some edits
and organize everything before adding it to the .tex file.

Claude Code is also able to provide immediate feedback on my writing,
and will sometimes suggest ways to elaborate on particular ways to express my thoughts.
I have always proofread and iterated many times with Claude Code before committing to a particular
phrasing or way of saying something.

A smaller part of my AI usage in writing was in generating some starting sentences which
could give me an idea of what I would like the final text to look like. This usage was especially
helpful when I was stuck without any idea of what to write. Although the generated sentences weren't
necessarily always being used, they were still helpful to give me some editing momentum.
In these cases, I would act more as a reviewer where I would use
my taste and the vision of what I wanted the paragraph to say to
help dictate the writing of Claude Code.

Overall, I am confident to take full responsibility of every potentially wrong claim
that is part of my thesis. For the literature review, I have verified the validity
of the JuMP section with Oscar Dowson, who is the expert on the subject, as well
as searched through lots of the history and documentation of AMPL to validate my claims
about how it worked. On CVXPY, I am confident about the exposition since I also have
quite a lot of experience working on the internal codebase, and have verified what
I talked about with other maintainers, including Steven Diamond, the original developer
of CVXPY. Although I used AI a lot to help my writing, the final product is an accumulation
of many choices of my own, from the initial organization of the thesis, down to proof-reading
many times every sentence that the AI has edited or generated.

## Miscellaneous

I can think of other usages that are worth mentioning: figures in LaTeX as well as formatting
and editing the thesis document in LaTeX. For these tasks, I delegated them almost completely
to the AI tools, which were surprisingly good at it.
I have verified the output of the PDF conforms to what I expected or wanted,
but have not looked at the actual .tex file as much (especially for the figures).
