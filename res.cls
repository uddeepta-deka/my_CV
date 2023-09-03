\typeout{Document Style `res' <26 Sep 89>.}

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{res}[2000/05/19 v1.4b Resume class]

%\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
%\DeclareOption{12pt}{\renewcommand\@ptsize{2}}

\PassOptionsToClass{11pt,12pt}{article}
\LoadClassWithOptions{article}

\newif\if@line
\newif\if@margin

\DeclareOption{line}{\@linetrue}
\DeclareOption{centered}{\@linefalse}

\DeclareOption{margin}{\@margintrue}
\DeclareOption{overlapped}{\@marginfalse}

\ExecuteOptions{overlapped,centered}
\ProcessOptions\relax

\nofiles


\newtoks\tabular@text		    
\newtoks\tabular@head		    
\newtoks\tabular@tail
\newtoks\@ta
\newtoks\undefined@token\undefined@token={}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\@printcentername{\begingroup
  \leavevmode\hbox to \textwidth{\hfil\@tablebox{\namefont\@name}\hfil}\par
  \@ifundefined{@addressone}{
  }{
    \@ifundefined{@addresstwo}{
      % only one address
      \leavevmode\hbox to \textwidth{\hfil\@tablebox{\@addressone}\hfil}\par
    }{
      % two addresses
      \leavevmode\hbox to \textwidth{\@tablebox{\@addressone}\hfil
				     \@tablebox{\@addresstwo}}\par
    }
  }
\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is used to print the name and address at the top of
% the page with a hline in between

\def\namefont{\large\bf}
\def\@linename{\begingroup
  \def\\{, }
  {\namefont\@name}
  \vskip 2pt
  \fullline
  \vskip 2pt
  % where do you live?
  \@ifundefined{@addressone}{%
    % do nothing
  }{%
    \leavevmode\hbox to \textwidth
      {\hfill\vbox{\hbox{\@addressone}
		   \hbox{\@addresstwo}
		  }%
      }\par
  }
\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEADINGS:
% There are two types of headings:
% 1) one with the name centered and the address centered or
%    in the left and right side if there are two address
% 2) one where the name is in the upper left corner 
%    the a line accross the paper
%    then the address all on one line in the right corner
%    the second address will be directly below the first if defined
%
\let\print@name\relax
\def\ds@centered{\ifx\print@name\relax\let\print@name\@printcentername\fi}
\def\ds@line{\ifx\print@name\relax\let\print@name\@linename\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use this to set the sectionwidth.
% It adjust the width of the text as well as the hoffset
% You probably shouldn't touch any of the size paramaters
% unless you really understand all of this but it is not
% hard.  Either way, it can only be executed once
%
\def\sectionfont{\bf}
\newdimen\sectionwidth
\newskip\sectionskip
\newdimen\resumewidth

\resumewidth=6.5in
\sectionskip=3.5ex plus 1ex minus -.2ex % values stolen from LaTeX

\def\newsectionwidth#1{
		     \sectionwidth=#1
		     \textwidth=\resumewidth
		     \advance\textwidth-\sectionwidth
		     \hsize=\textwidth
		     \hoffset=\sectionwidth
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for sectiontitles that are entirely in the left margin.
% multiline sectiontitles are permited and will be broken by
% \TeX{} to fit into a box \verb|\sectionwidth| wide.  It is advised
% that \verb|\\| be used to break the lines by hand as \TeX{} will
% probably not do what you want.
%
% When using this with {\tt tabbing} and {\tt list} (or anything
% that is made out of {\tt list}) put the \section's inside of
% the \verb|\begin{}|  and the \verb|\item|Eg.
% \begin{verbatim}
% \begin{trivlist}
% \item[]
% \section{foo}
% text
% \end{trivlist}
% \end{verbatim}
%
\def\boxed@sectiontitle#1{
  \ifx\\\@tabcr    
    \@stopfield
   \else
     \@@par	

  \fi
  \begingroup
  \everypar={}
  \def\par{\@@par}
  \let\\=\@normalcr
  \addpenalty{\@secpenalty}

  \addvspace{\sectionskip}
  \hbox to 0pt{
    \hss
    \vtop to 0pt{
      \leftskip=0pt
      \hsize=\sectionwidth
      \textwidth=\sectionwidth
      \raggedright 
      \sectionfont
      #1\vss	       
    }
  }
  \addpenalty{-\@secpenalty}
  \vskip-\baselineskip
  \endgroup
  \ifx\\\@tabcr
    \@startline
    \ignorespaces
  \else
    \vskip-\parskip
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for section titles that are entirely above the section text

\def\unboxed@sectiontitle#1{%
  \ifx\\\@tabcr 
    \@stopfield
   \else
     \@@par
  \fi
  \begingroup
  \everypar={}
  \def\par{\@@par}
  \def\\{ }
  \addpenalty{\@secpenalty}
  \addvspace{\sectionskip}
  \hbox to 0pt{\hss\hbox to \sectionwidth{\sectionfont#1\hss}}
  \addpenalty{-\@secpenalty} 
  \endgroup
  \ifx\\\@tabcr 
    \@startline
  \else
    \vskip-\parskip
  \fi
  \ignorespaces
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There are two types of section headings:
% 1) the section heading is all on one line and directly
%    below it, is the body of the text
% 2) the section heading is entirely in the left margin
%    (possibly taking multiple lines) with the body of
%    the text next to it
%
\let\@@section\relax
\def\ds@overlapped{\ifx\@@section\relax\newsectionwidth{0.5in}\let
  \@@section\unboxed@sectiontitle\fi}
\def\ds@margin{\ifx\@@section\relax\newsectionwidth{1.3in}\let
  \@@section\boxed@sectiontitle\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULTS: (some of them)
%
% centered name
% overlapped section titles
%
% format is:
%    title	 employer
%    location	 dates
%    body
% with everything in the left of its column

%\input article.sty

\if@line\ds@line\else\ds@centered\fi
\if@margin\ds@margin\else\ds@overlapped\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% typeset resume all nice and pretty
%
\def\Resume{{R\'{e}sum\'{e}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% makes a line of width \textwidth starting at -\hoffset
%
\def\fullline{		% hrules only listen to \hoffset
  \nointerlineskip	% so I have this code	  
  \moveleft\hoffset\vbox{\hrule width\textwidth} 
  \nointerlineskip
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a multiline box.
%
\def\@tablebox#1{\begin{tabular}[t]{@{}l@{\extracolsep{\fill}}}#1\end{tabular}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use this to define your name
%
\def\name#1{\def\@name{#1}}

\def\@name{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use this to define your address, this may be called more than once.
%
\let\@addressone\relax
\let\@addresstwo\relax

\def\address#1{
  \@ifundefined{@addressone}{\def\@addressone{#1}}{\def\@addresstwo{#1}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if you want to print your name and address is a slightly
% different format than suggested, then this can be used
% to place it exactly where you want
%
\def\opening{\def\@opening{}
  \begingroup
  \leftskip=-\hoffset	      
  \advance\textwidth\hoffset 
  \hsize=\textwidth 

  \let\par=\@@par
  \parindent=0pt
  \parskip=0pt
  \print@name
  \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all of the resume goes in the resume environment
%
\newenvironment{resume}{\begingroup
		       \@ifundefined{@opening}{\opening}{}
}{\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gives you a tabular environment with n equally spaced columns
% \begin{ncolumn}{#} ... \end{ncolumn}

\def\@endpbox{\par\egroup\hfil}
\let\@@endpbox=\@endpbox

\newdimen\@columnwidth	  % the width of each column equal to
\def\ncolumn#1{%
  % \@columnwidth = \textwidth / #1
  \@columnwidth=\textwidth \divide\@columnwidth by #1
  \begin{tabular*}{\textwidth}[t]%
	{*{#1}{@{}p{\@columnwidth}@{\extracolsep{\fill}}}}
}

\def\endncolumn{\end{tabular*}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   \employer{text} defines employer to be text
%   \location{text} defines location to be text
%   \dates{text}    defines dates    to be text
%   \title{text}    defines title    to be text
%   \body
%

\def\employer#1{\def\@employer{\print@employer{#1}}}
\def\location#1{\def\@location{\print@location{#1}}}
\def\dates#1{\def\@dates{\print@dates{#1}}}
\def\title#1{\def\@title{\print@title{#1}}}

\let\l@justify\raggedright
\let\r@justify\raggedleft
\let\c@justify\centering


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \@format{name}{justify}
% will define \print@#1 to print it's one argument 
% justified according to #2 which can be
%	  l = left
%	  r = right
%	  c = center
%
% eg.
%    \@format{employer}{c}
%    is the same as \def\print@employer#1{{\centering #1\par}}
%
\def\@format#1#2{%
  \expandafter\gdef\csname print@#1\endcsname##1{%
    {\csname#2@justify\endcsname##1\par}}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is used to define how the position environment should
% formated.
%
% \begin{format} positioning text \end{format}
% where positioning text may be
%  \employer{pos}
%  \location{pos}
%  \dates{pos}
%  \title{pos}
%  \body	    (for the body of the position environment)
%   where pos is 
%     l for left
%     r for right
%     c for center
% use \\ to break the line
% you don't have to use all of the options.
% on any one line, you should indicate what you want on that line
% and where it should go within its column.
% eg.
% the following prints the employer in the left with the location
% centered within that its column.  It then prints the date on the
% right.  Then it prints the body of the position environment. Then
% it prints the title centered within its column; as there is only
% one column here it is really just centered.
%
% \begin{format}
% \employer{l}\location{c}\\
% \dates{r}\\
% \body\\
% \title{c}\\
% \end{format}

\newcounter{numberofcolumns}
\newenvironment{format}{%
  \def\end@line@head{\append@tabular@head{tabular@text}\tabular@text={}%
    \c@numberofcolumns 0}
  \def\end@line@tail{\append@tabular@tail{tabular@text}\tabular@text={}%
    \c@numberofcolumns 0}
  \tabular@text={}
  \tabular@head={}
  \tabular@tail={}
  \c@numberofcolumns 0
  \let\\=\end@line@head
  \def\employer##1{\advance\c@numberofcolumns 1
		   \@format{employer}{##1}
		   \append@tabular@text{employer}}
  \def\location##1{\advance\c@numberofcolumns 1
		   \@format{location}{##1}
		   \append@tabular@text{location}}
  \def\dates##1{\advance\c@numberofcolumns 1
		\@format{dates}{##1}
		\append@tabular@text{dates}}
  \def\title##1{\advance\c@numberofcolumns 1
		 \@format{title}{##1}
		\append@tabular@text{title}}
  \def\body{\iftoks\tabular@head\undefined@token\then
	    \else
	      \@append{\noexpand\\}\to\tabular@head
	    \skotfi
	    \let\\=\end@line@tail}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%taken from page 378 of TeXbook but freely hacked
%
% appends the expansion of #1 to the token list #2

\def\@append#1\to#2{%
  \@ta=\expandafter{#1}%
  \xdef\@append@temp{\the#2\the\@ta}
  \global#2=\expandafter{\@append@temp}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHAA006%vaxb.rhbnc.ac.uk@NSS.Cs.Ucl.AC.UK
% texhax.88.078
% is used to see if two token lists are equal
% there must be a better way
%

\let \then = \empty
\def \iftoks #1#2\then #3\else #4\skotfi{
		\edef \1{\the #1}
		\edef \2{\the #2}
		\ifx \1\2\then #3\else #4\fi}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \append@tabular@text{command}
%
% appends command to the end of \tabular@text.
% NOTE: command MUST be a command but without the \
%	Eg. \append@tabular@text{relax}
%
% used to define \tabular@text for the tabular environment
% used by append@tabular@head and append@tabular@tail
%

\def\append@tabular@text#1{%
\iftoks\tabular@text\undefined@token\then
  \global\tabular@text=\expandafter{\csname @#1\endcsname}
\else
  \@append{&}\to\tabular@text
  \@append{\csname @#1\endcsname}\to\tabular@text
\skotfi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% append@tabular@head
%
% appends command to the end of \tabular@text@head
% NOTE: command MUST be a command but without the \
%	Eg. \append@tabular@head{relax}
%
% used to define \tabular@head for the tabular environment
% used by the position environment
%
\def\append@tabular@head#1{%
  \ifnum\the\c@numberofcolumns=0\relax
  \else
    \iftoks\tabular@head\undefined@token\then
      \relax
    \else
      \@append{\noexpand\\}\to\tabular@head
      \@append{\noexpand\penalty-\@secpenalty}\to\tabular@head
    \skotfi
    \@append{\noexpand\begin{ncolumn}}\to\tabular@head
    \@append{\expandafter{\the\c@numberofcolumns}}\to\tabular@head
    \@append{\the\csname#1\endcsname}\to\tabular@head
    \@append{\noexpand\end{ncolumn}}\to\tabular@head
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% append@tabular@tail
%
% appends command to the end of \tabular@text@htail
% NOTE: command MUST be a command but without the \
%	Eg. \append@tabular@tail{relax}
%
% used to define \tabular@tail for the tabular environment
% used by the position environment
%
\def\append@tabular@tail#1{%
  \ifnum\the\c@numberofcolumns=0\relax
  \else
    \iftoks\tabular@tail\undefined@token\then
    \else
      \@append{\noexpand\\}\to\tabular@tail
      \@append{\noexpand\penalty-\@secpenalty}\to\tabular@tail
    \skotfi
    \@append{\noexpand\begin{ncolumn}}\to\tabular@tail
    \@append{\expandafter{\the\c@numberofcolumns}}\to\tabular@tail
    \@append{\the\csname#1\endcsname}\to\tabular@tail
    \@append{\noexpand\end{ncolumn}}\to\tabular@tail
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% put the actual job descriptions here
% \begin{postion} ... \end{position}
% in the ... describe the position.
% don't put the \dates \location etc in here. define them before hand
\newenvironment{position}%
  {%
   \begingroup
     \par
       \the\tabular@head
%     \addpenalty{-\@secpenalty}% bad place for a page break
     \penalty -\@secpenalty % bad place for a page break
     \penalty 10000
     \ignorespaces
  }{%
       \the\tabular@tail
%     \addpenalty{\@secpenalty}% good place for a page break
     \penalty \@secpenalty % good place for a page break
    \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULTS: (the rest of them)
%
% centered name
% overlapped section titles
%
% format is:
%    title	 employer
%    location	 dates
%    body
% with everything in the left of its column

\@secpenalty = -500
\topmargin 0pt
\headheight 0pt
\headsep 0pt
\textheight 9in
\parindent 0pt
\topmargin 0in
\oddsidemargin 0pt
\evensidemargin 0pt
\marginparwidth 0pt
\parindent 0pt
\parskip \baselineskip
\setcounter{secnumdepth}{0}
\def\@listI{\leftmargin\leftmargini
\topsep 0pt 
\parskip 0pt
\partopsep 2pt plus 2pt
\parsep 2pt plus 2pt
\itemsep \parsep}

\pagestyle{empty}  % don't want page numbers

\begin{format}
\title{l}\employer{r}\\
\location{l}\dates{r}\\
\body\\
\end{format}

\let\section\@@section