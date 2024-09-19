%% filename: amsbibs.bst
%% date: 2024/01/14
%%
%% This is file `amsbibs.bst',
%% to convert BibTex databases to AMSBIB referencing style in citation order
%%
%% Created  on 2023.06.06 by V.Kozyakin, by heavily modifying amsrn.bst
%% email: kozyakin<at>iitp.ru
%% 
%% Modified on 2024.01.14 by changing the sort rules to automatically create 
%% substitution for an empty or missing key field to reject possible excessive 
%% warnings.

%%
%% This is file `amsrn.bst',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% amsxport.dtx  (with options: `bst,sort,plain')
%% 
%% Copyright 2001, 2004, 2010 American Mathematical Society.
%% 
%% American Mathematical Society
%% Technical Support
%% Publications Technical Group
%% 201 Charles Street
%% Providence, RI 02904
%% USA
%% tel: (401) 455-4080
%%      (800) 321-4267 (USA and Canada only)
%% fax: (401) 331-3842
%% email: tech-support<at>ams.org
%% 
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%% 
%% This work has the LPPL maintenance status `maintained'.
%% 
%% The Current Maintainer of this work is the American Mathematical
%% Society.
%% 
ENTRY
  {
     address      author      booktitle chapter
     doi          edition     editor    eprint
     howpublished institution isbn      issn
     journal      key         language  month
     mrnumber     note        number    organization
     pages        pagetotal   publisher school
     series       subtitle    title     type
     url          volume      year      zblnumber
  }
  { }
  { label }
MACRO {jan} {"January"}
MACRO {feb} {"February"}
MACRO {mar} {"March"}
MACRO {apr} {"April"}
MACRO {may} {"May"}
MACRO {jun} {"June"}
MACRO {jul} {"July"}
MACRO {aug} {"August"}
MACRO {sep} {"September"}
MACRO {oct} {"October"}
MACRO {nov} {"November"}
MACRO {dec} {"December"}
STRINGS { p s t l }
INTEGERS { len ptr }

FUNCTION {NOT} { { #0 } { #1 } if$ }

FUNCTION {AND} { 'skip$ { pop$ #0 } if$ }

FUNCTION {OR} { { pop$ #1 } 'skip$ if$ }

FUNCTION {TRUE} { #1 }

FUNCTION {FALSE} { #0 }

FUNCTION {incr.ptr} { ptr #1 + 'ptr := }

FUNCTION {current.char} { ptr #1 substring$ }

FUNCTION {copy.two.chars} { t * incr.ptr s current.char * incr.ptr }

FUNCTION {sortify} {
    purify$
    "l" change.case$
}

FUNCTION {field.or.null} {
    duplicate$ empty$
        { pop$ "" }
        'skip$
    if$
}

FUNCTION {missing.or.empty} { duplicate$ missing$ swap$ empty$ OR }

FUNCTION {missing.warning} {
    "missing " swap$ * " in " * cite$ * warning$
}

INTEGERS { string.ptr }

FUNCTION {string.length} {
    #1 'string.ptr :=
    { duplicate$ string.ptr #1 substring$ "" = 'FALSE 'TRUE if$ }
        { string.ptr #1 + 'string.ptr := }
    while$
    pop$
    string.ptr #1 -
}

FUNCTION {format.title}{
    duplicate$
    missing.or.empty
        { pop$ "" }
        { "t" change.case$ }
    if$
}

FUNCTION {start.field} {
    " " * write$
}

FUNCTION {fin.field} { newline$ }

FUNCTION {write.field} {
    duplicate$
    missing$
        { pop$ missing.warning }
        { duplicate$ empty$
            { pop$ missing.warning }
            { swap$ start.field write$ fin.field }
          if$
        }
    if$
}

FUNCTION {optional.field} {
    duplicate$
    missing.or.empty
        { pop$ pop$ }
        { swap$ start.field write$ fin.field }
    if$
}

FUNCTION {optional.title.field} {
    duplicate$
    missing.or.empty
        { pop$ pop$ }
        { format.title swap$ start.field write$ fin.field }
    if$
}

FUNCTION {optional.url.field} {
    duplicate$
    missing.or.empty
        { pop$ pop$ }
        { swap$ start.field write$ "}}" write$ fin.field }
    if$
}

FUNCTION {optional.arxiv.field} {
    duplicate$
    missing.or.empty
        { pop$ pop$ }
        { swap$ start.field "\href{http://arXiv.org/abs/" 
          write$ write$ "}{\allowbreak " write$ eprint write$ "}\miscnote " 
          write$ fin.field }
    if$
}

FUNCTION {optional.mr.field}
{ duplicate$ missing$
    { pop$ "" }
    'skip$
  if$
  duplicate$ empty$
    'pop$
    { " XX" *
% Extract only the first part of the field mrnumber of the form {####### something}
      purify$
      #1 "{ff{, }}" format.name$
      #1 "{ll}" format.name$
      duplicate$
      #1 #2 substring$ "MR" =
        {#3 #10 substring$}
        'skip$
      if$
% end of extraction  of #######
          swap$ "" * write$
          "" swap$ * "}" * write$ fin.field
    }
  if$
}

FUNCTION {optional.zbl.doi.field} {
    duplicate$
    missing.or.empty
        { pop$ pop$ }
        {
          swap$ "" * write$
          "" swap$ * "}" * write$ fin.field
        }
    if$
}

INTEGERS { nameptr numnames namesleft }

STRINGS { namelist fieldname }

FUNCTION {format.name} { "{f.}{~vv}{~ll}{, jj}" format.name$ }

FUNCTION {optional.name.field}{
    duplicate$ missing.or.empty
        { pop$ pop$ }
        { swap$ 'fieldname :=
          duplicate$ num.names$
          'namesleft :=
          #1 'ptr :=
          { namesleft #0 > }
            { ptr #1 > 
              {}
              {fieldname start.field}
              if$
              duplicate$ ptr format.name write$
              %fin.field
              namesleft #1 >
              {", " write$}
              {newline$}
              if$
              ptr #1 + 'ptr :=
              namesleft #1 - 'namesleft :=
            }
          while$
        pop$
        }
    if$
}

FUNCTION {optional.type.field}
{ duplicate$ missing.or.empty
    { type$ "mastersthesis" = { "Master's Thesis" }
        { type$ "phdthesis" = { "Ph.D. Thesis" }
          { "" } if$ } if$
      swap$ pop$
    }
    'skip$
  if$
  duplicate$ empty$
    { pop$ pop$ }
    { swap$ start.field write$ fin.field }
  if$
}

INTEGERS {find.length search.start search.end done}

STRINGS {find.string find.pattern}

FUNCTION {is.contains}
{
  'find.pattern :=
  'find.string :=
  find.pattern string.length 'find.length :=
  #1 'search.start :=
  find.string string.length find.length - #2 + 'search.end :=
  #0 'done :=
  { search.start search.end < }
  {
    find.string search.start find.length substring$ find.pattern =
      { 
        #1 'done :=
        search.end 'search.start :=%% stop searching
      }
      { #1 search.start + 'search.start := }
    if$
  }
  while$
  done
}

FUNCTION {url.mrnumber.note} {
    "\miscnote" note optional.field
    "\crossref{https://dx.doi.org/" doi optional.zbl.doi.field
    mrnumber missing.or.empty
      {skip$}
      {"\mathscinet{https://www.ams.org/mathscinet-getitem?mr=" 
        mrnumber optional.mr.field}
    if$
    "\zmath{https://www.zentralblatt-math.org/zmath/search/?an=Zbl " 
      zblnumber optional.zbl.doi.field
    url missing.or.empty
    {skip$}
    {  url "mi.mathnet.ru" is.contains
        {"\mathnet{" url optional.zbl.doi.field}
        {"\elink{\url{" url optional.url.field}
      if$
    }
    if$
}

FUNCTION {start.entry} {
    newline$
    language "russian" =
          { "\RBibitem{" }
          { "\Bibitem{" }
      if$
    cite$ * "}" * write$
    newline$
}

FUNCTION {fin.entry} { newline$ }

FUNCTION {article} {
    start.entry
    "\by" author optional.name.field
    "\paper" title optional.field
    "\jour" journal optional.field
    "\yr" year write.field
    "\vol" volume optional.field
    "\issue" number optional.field
    "\monthissue" month optional.field
    "\pages" pages optional.field
    "\arxiv" eprint optional.arxiv.field
    url.mrnumber.note
    fin.entry
}

FUNCTION {inproceedings} {
    start.entry
    "\by" author optional.name.field
    "\paper" title optional.field
    "\ed" editor optional.name.field
    "\inbook" booktitle optional.field
    "\procinfo" organization optional.field
    "\bookvol" volume optional.field
    "\edition" edition optional.field
    "\yr" year write.field
    "\serial" series optional.field
    "\pages" pages optional.field
    "\publ" publisher optional.field
    "\publaddr" address optional.field
    "\monthissue" month optional.field
    "\arxiv" eprint optional.arxiv.field
    url.mrnumber.note
    fin.entry
}

FUNCTION {inbook} { inproceedings }

FUNCTION {incollection} { inproceedings }

FUNCTION {conference} { inproceedings }

FUNCTION {book} {
    start.entry
    "\by" author optional.name.field
    "\ed" editor optional.name.field
    "\book" title missing$ { booktitle } { title } if$
      optional.field
    "\bookinfo" type optional.type.field
    "\edition" edition optional.field
    "\serial" series optional.field
    "\bookvol" volume optional.field
    "\finalbookinfo" howpublished optional.field
    "\isbn" isbn optional.field
    "\yr" year write.field
    "\issue" number optional.field
    "\publ" publisher optional.field
    organization missing.or.empty
        { "\publ" institution optional.field }
        { "\publ" organization optional.field }
    if$
    "\publaddr" address optional.field
    "\totalpages" pagetotal optional.field
    "\arxiv" eprint optional.arxiv.field
    url.mrnumber.note
    fin.entry
}

FUNCTION {techreport} {
    start.entry
    "\by" author optional.name.field
    "\preprint" title missing$ { booktitle } { title } if$
      optional.field
    "\preprintinfo" type optional.type.field
    "\yr" year write.field
    "\issue" number optional.field
    "\monthissue" month optional.field
    "\publ" institution optional.field
    "\publaddr" address optional.field
    "\totalpages" pagetotal optional.field
    "\arxiv" eprint optional.arxiv.field
    url.mrnumber.note
    fin.entry
}

FUNCTION {booklet} { book }

FUNCTION {manual} { book }

FUNCTION {mastersthesis} { book }

FUNCTION {phdthesis} { book }

FUNCTION {proceedings} { book }

FUNCTION {collection} { book }

FUNCTION {unpublished} { book }

FUNCTION {misc} { book }

FUNCTION {default.type} { misc }

READ

FUNCTION {chop.word} {
    's :=
    'len :=
    s #1 len substring$ =
        { s len #1 + global.max$ substring$ }
        's
    if$
}

FUNCTION {sort.format.title} {
    't :=
    "A " #2
      "An " #3
        "The " #4 t chop.word
      chop.word
    chop.word
    sortify
    #1 global.max$ substring$
}

FUNCTION {sort.format.names} {
    's :=
    #1 'ptr :=
    ""
    s num.names$ 'numnames :=
    numnames 'namesleft :=
      { namesleft #0 > }
      { ptr #1 >
          { "   " * }
          'skip$
        if$
        s ptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
        ptr numnames = t "others" = AND
          { "et al" }
          { t sortify }
        if$
        *
        ptr #1 + 'ptr :=
        namesleft #1 - 'namesleft :=
      }
    while$
}

FUNCTION {key.autogenerated} {
    cite$ sortify #1 #3 substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { key.autogenerated }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { key.autogenerated }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { key.autogenerated }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { key.autogenerated }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort} {
    type$ "book" = type$ "inbook" = OR type$ "collection" = OR
        'author.editor.sort
        { type$ "proceedings" =
            'editor.organization.sort
            { type$ "manual" =
                'author.organization.sort
                'author.sort
              if$
            }
          if$
        }
    if$
    "    " *
    year field.or.null sortify * "    " *
    title field.or.null sort.format.title *
    #1 entry.max$ substring$
    'sort.key$ :=
}

ITERATE {presort}

SORT

FUNCTION {write.with.newlines}
{ 's :=  #1 'ptr :=
  { s ptr #2 + #1 substring$ "" = NOT }
  { s ptr #3 substring$ "^^M" =
    { s #1 ptr #1 - substring$ write$ newline$
      ptr #3 + 'ptr :=
      s ptr global.max$ substring$ 's :=
      #1 'ptr :=
    }
    { incr.ptr }
    if$
  }
  while$
  s write$ newline$
}

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib} {
"\begin{thebibliography}{"  longest.label  * "}" *
  write$ newline$
    preamble$ empty$
        'skip$
        { preamble$ write.with.newlines }
    if$
    "% \bib, bibdiv, biblist are defined by the amsrefs package."
        write$ newline$
}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {begin.bib}

ITERATE {call.type$}

EXECUTE {end.bib}
