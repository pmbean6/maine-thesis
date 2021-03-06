%% Copyright (C) 2003 by Jim Kenneally
%% 
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% 
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%%
%% This work has the LPPL maintenance status `maintained'.
%% 
%% The Current Maintainer of this work is R. Padraic Springuel.
%% Please report all bugs and problems (particularly formatting that
%% the UMaine Graduate School wants changed) to:
%%  rpspringuel@gmail.com
%%

%%%%%%%%%%%%%%%%%%%%%
% ------IDENTIFICATION------
%%%%%%%%%%%%%%%%%%%%%
\ProvidesClass{maine-thesis}[2017/05/03 v1.13 Maine thesis class]

\NeedsTeXFormat{LaTeX2e}[1999/12/01]

%%%%%%%%%%%%%%%%%%%%%
% ------INITIAL CODE------
%%%%%%%%%%%%%%%%%%%%%
\newif\ifdraft\draftfalse
\newif\iftwoside\twosidefalse
\newif\ifofficial\officialtrue
\newif\ifunbound\unboundfalse
\newif\ifmt@legacycaptions\mt@legacycaptionsfalse
\newcommand\docsize{}
\newcommand\side{oneside}
\newcounter{secnumdefault}
\setcounter{secnumdefault}{3}
\newcounter{head} %Heading styles get numbered so that \ifcase can be used when determining which heading style is currently set instead of a nested set of \if and \else.
\setcounter{head}{1000} %The default value is set very large so that adding new styles shouldn't necessitate changing it.
\def\@margg{1.5in}

%%%%%%%%%%%%%%%%%%%%%
% ------DECLARATION OF OPTIONS------
%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{10pt}{\officialfalse\renewcommand\docsize{10pt}}
\DeclareOption{11pt}{\renewcommand\docsize{11pt}}
\DeclareOption{12pt}{\renewcommand\docsize{12pt}}
\DeclareOption{draft}{\drafttrue
	\ExecuteOptions{10pt}
	\PassOptionsToClass{draft}{report}
	\newcommand{\drafttext}{\sffamily\small{DRAFT}
	\officialfalse}
}
\DeclareOption{twoside}{\officialfalse\twosidetrue\renewcommand\side{twoside}}
\DeclareOption{unbound}{\officialfalse\unboundtrue
	\def\@margg{1in}}
\DeclareOption{apa}{\setcounter{secnumdefault}{0}\setcounter{head}{0}}
\DeclareOption{chicago}{\setcounter{secnumdefault}{0}\setcounter{head}{1}}
\DeclareOption{headings}{\setcounter{secnumdefault}{0}\setcounter{head}{2}}
\DeclareOption{idecimal}{\setcounter{secnumdefault}{3}\setcounter{head}{3}}
\DeclareOption{jdecimal}{\setcounter{secnumdefault}{3}\setcounter{head}{1000}}
\DeclareOption{legacycaptions}{\mt@legacycaptionstrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

%%%%%%%%%%%%%%%%%%%%%
% ------EXECUTION OF OPTIONS------
%%%%%%%%%%%%%%%%%%%%%
\ExecuteOptions{12pt}
\ProcessOptions

%%%%%%%%%%%%%%%%%%%%%
% ------PACKAGE LOADING------
%%%%%%%%%%%%%%%%%%%%%
\LoadClass[\docsize,\side]{report}[2007/10/19 v1.4h Standard LaTeX document class]
\RequirePackage[T1]{fontenc}[2005/09/27 v1.99g Standard LaTeX package]
\RequirePackage{color}[2005/11/14 v1.0j Standard LaTeX Color (DPC)]
\RequirePackage{tocvsec2}[2010/02/27 v1.2b variable ToC section entries]
\RequirePackage[norule]{footmisc}[2009/09/15 v5.5a a miscellany of footnote facilities]
\RequirePackage{soul}[2003/11/17 v2.4 letterspacing/underlining  (mf)]
\RequirePackage{afterpackage}[2006/01/17 v1.1 Apply Commands After Package (NCC)]
\RequirePackage{etoolbox}[2015/08/02 v2.2a e-TeX tools for LaTeX (JAW)]
\RequirePackage[none]{hyphenat}[2009/09/02 v2.3c hyphenation utilities]
\RequirePackage{iftex}[2013/04/04 v0.2 Provides if(tex) conditional for PDFTeX, XeTeX, and LuaTeX]
\RequirePackage{geometry}[2010/09/12 v5.6 Page Geometry]
\RequirePackage{xstring}[2013/10/13 v1.7c  String manipulations (C Tellechea)]
\AfterPackage{hyperref}{% There are a few changes that are required for the hyperref package, so we make those changes if it is loaded.
	\hypersetup{ pdfdisplaydoctitle=true}
	\AtBeginDocument{
		\hypersetup{	
			pdftitle=\@title,
			pdfauthor=\@author,
			pdfcreator=\relax,
			pdfproducer=\relax % These could be changed, but for the thesis, I left them blank.
			}
	}
	% Graduate School requirements mandate a slight modification to hyperref's
	% redefinition of the caption command.
	\long\def\@caption#1[#2]#3{%
	  \ifmt@legacycaptions%
	    \def\mt@captiontext{#3}%
	  \else%
	    \IfStrEq{#2}{#3}{\def\mt@captiontext{#3}}{\def\mt@captiontext{#2\ \ignorespaces#3}}%
	  \fi%
	  \expandafter\ifx\csname if@capstart\expandafter\endcsname
	                  \csname iftrue\endcsname
	    \global\let\@currentHref\hc@currentHref
	  \else
	    \hyper@makecurrent{\@captype}%
	  \fi
	  \@ifundefined{NR@gettitle}{%
	    \def\@currentlabelname{#2}%
	  }{%
	    \NR@gettitle{#2}%
	  }%
	  \par\addcontentsline{\csname ext@#1\endcsname}{#1}{%
	    \protect\numberline{\csname fnum@#1\endcsname}{\ignorespaces #2}%
	  }%
	  \ifnum\value{part}>1
	  \par\addcontentsline{\csname ext@#1\endcsname2}{#1}{%
	    \protect\numberline{\csname fnum@#1\endcsname}{\ignorespaces #2}%
	  }%
	  \fi
	  \begingroup
	    \@parboxrestore
	    \if@minipage
	      \@setminipage
	    \fi
	    \normalsize
	    \expandafter\ifx\csname if@capstart\expandafter\endcsname
	                    \csname iftrue\endcsname
	      \global\@capstartfalse
	      \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces\mt@captiontext}%
	    \else
	      \@makecaption{\csname fnum@#1\endcsname}{%
	        \ignorespaces
	        \ifHy@nesting
	          \expandafter\hyper@@anchor\expandafter{\@currentHref}{\mt@captiontext}%
	        \else
	          \Hy@raisedlink{%
	            \expandafter\hyper@@anchor\expandafter{%
	              \@currentHref
	            }{\relax}%
	          }%
	          \mt@captiontext%
	        \fi
	      }%
	    \fi
	    \par
	  \endgroup
	}
}

\ifPDFTeX
	\pdfsuppressptexinfo=-1 %to remove some useless tags generated by pdftex
\fi
	
%%%%%%%%%%%%%%%%%%%%%
% ------MAIN CODE------
%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
% Variable Declarations
%%%%%%%%%%%%%%%%%%%%%

\def\@title{}
\def\@author{}
\def\@authorpronoun{}
\def\@degreesheld{}
\def\@degree{}
\def\@program{}
\def\@submitdate{}
\def\@principaladvisor{}
\def\@secondadvisor{}
\def\@principalshort{}
\def\@firstreader{}
\def\@secondreader{}
\def\@thirdreader{}
\def\@fourthreader{}
\def\@fifthreader{}
\def\@bibfiles{}
\def\@bibtitle{REFERENCES}
\def\@type{DISSERTATION}
\def\@Type{Dissertation}
\def\@NumParts{1}
\def\@FirstLength{0}
\def\@FirstListStart{}
\def\@FirstListEnd{}
\def\@LastLength{0}
\def\@LastListStart{}
\def\@LastListEnd{}
\def\@ChapListStart{}
\def\@ChapListEnd{}
\def\@LastLevel{0}

\newif\ifmultipleappendices\multipleappendicesfalse
\newif\ifcopyrightpage\copyrightpagefalse
\newif\ifloftspace\loftspacetrue
\newif\ifbigtitlepage\bigtitlepagefalse
\newif\ifverybigtitlepage\verybigtitlepagefalse
\newif\ifapp\appfalse
\newif\ifsinglepart\singleparttrue

\newcount\numcomm \numcomm=4
\newcount\numadv \numadv=1
\newcounter{partlength}[part]

\renewcommand*\contentsname{TABLE OF CONTENTS}
\renewcommand*\listfigurename{LIST OF FIGURES}
\renewcommand*\listtablename{LIST OF TABLES}
\newcommand*\listname{LIST OF}
\renewcommand*\bibname{\@bibtitle}
\renewcommand*\indexname{INDEX}
\renewcommand*\partname{VOLUME}
\renewcommand*\chaptername{Chapter}
\newcommand*\chapternamep{\chaptername s}
\newcommand*\AppendixName{APPENDIX}
\renewcommand*\appendixname{Appendix}

%%%%%%%%%%%%%%%%%%%%%
% Variable Modification Commands
%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\author}[1]{%
	\ifx\empty#1\empty\else\gdef\@author{#1}\fi}
\newcommand{\authorpronoun}[1]{%
	\ifx\empty#1\empty\else\gdef\@authorpronoun{#1}\fi}
\renewcommand{\title}[1]{%
	\ifx\empty#1\empty\else\gdef\@title{#1}\fi}
\newcommand{\degreesheld}[1]{%
	\ifx\empty#1\empty\else\gdef\@degreesheld{#1}\fi}
\newcommand{\degree}[1]{%
	\ifx\empty#1\empty\else\gdef\@degree{#1}\fi}
\newcommand{\program}[1]{%
	\ifx\empty#1\empty\else\gdef\@program{#1}\fi}
\newcommand{\submitdate}[1]{%
	\ifx\empty#1\empty\else\gdef\@submitdate{#1}\fi}
\newcommand{\principaladvisor}[2][\empty]{%
	\ifx\empty#1\empty\else\gdef\@principalshort{\sloppy#1}\fi%
	\ifx\empty#2\empty\else\gdef\@principaladvisor{\sloppy#2}\fi%
	}
\newcommand{\secondadvisor}[1]{%
	\ifx\empty#1\empty\else\gdef\@secondadvisor{\sloppy#1}\fi
	\twoadvisors}
\newcommand{\principalshort}[1]{%
	\ifx\empty#1\empty\else\gdef\@principalshort{#1}\fi}
\newcommand{\firstreader}[1]{%
	\ifx\empty#1\empty\else\gdef\@firstreader{\sloppy#1}\fi
	\members{1}}
\newcommand{\secondreader}[1]{%
	\ifx\empty#1\empty\else\gdef\@secondreader{\sloppy#1}\fi
	\members{2}}
\newcommand{\thirdreader}[1]{%
	\ifx\empty#1\empty\else\gdef\@thirdreader{\sloppy#1}\fi
	\members{3}}
\newcommand{\fourthreader}[1]{%
	\ifx\empty#1\empty\else\gdef\@fourthreader{\sloppy#1}\fi
	\members{4}}
\newcommand{\fifthreader}[1]{%
	\ifx\empty#1\empty\else\gdef\@fifthreader{\sloppy#1}\fi
	\members{5}}
\newcommand{\bibfiles}[1]{%
	\ifx\empty#1\empty\else\gdef\@bibfiles{#1}\fi}
\newcommand{\bibtitle}[1]{%
	\ifx\empty#1\empty\else\gdef\@bibtitle{#1}\fi}
\newcommand{\members}[1]{\numcomm=#1}
\newcommand{\twoadvisors}{\numadv=2}
\newcommand{\oneadvisor}{\numadv=1}
\newcommand{\thesis}{
	\gdef\@type{THESIS}
	\gdef\@Type{Thesis}}
\newcommand{\project}{
	\gdef\@type{PROJECT}
	\gdef\@Type{Project}}
\newcommand{\compresstitlepage}[1][1]{
	\ifcase#1
		\relax
	\or
		\bigtitlepagetrue
	\or
		\bigtitlepagetrue
		\verybigtitlepagetrue
	\fi
}

%%%%%%%%%%%%%%%%%%%%%
% Special Commands
%%%%%%%%%%%%%%%%%%%%%
\newcommand{\comment}[1]{
	\ifdraft
	\marginpar{
		\color{red}\flushleft\scriptsize\setlength{\baselineskip}{7pt}
		{\MakeUppercase{Note}: #1}}
	\fi
}

\newcommand{\ignore}[1]{}

\newcommand{\toclabel}[1]{%
	\addtocontents{toc}{\protect\pagebreak[3]}
	\addtocontents{toc}{\addvspace{2.25em \@plus\p@}
	\parindent \z@ \rightskip \@pnumwidth
	#1}%
}

\newcommand{\pocket}[1]{
	\refstepcounter{chapter}
	\addtocontents{toc}{\protect\pagebreak[2]\vskip 10pt plus 1pt minus 1pt}
	\ifapp
		\ifmultipleappendices
			\typeout{<---- Appendix \thechapter ---->}
		\addtocontents{toc}{\protect\@dottedtocline{0}{0em}{1.4em}{\AppendixName\space\thechapter\space -- \texorpdfstring{\MakeUppercase{#1}}{#1}}{Pocket}}
		\else
			\typeout{<---- APPENDIX ---->}%
		\addtocontents{toc}{\protect\@dottedtocline{0}{0em}{1.4em}{\AppendixName\space -- \texorpdfstring{\MakeUppercase{#1}}{#1}}{Pocket}}
		\fi
	\else
		\typeout{*** \@chapapp\space\thechapter\space ****}
		\addtocontents{toc}{\protect\@dottedtocline{0}{0em}{1.4em}{\protect\numberline{\thechapter.}\space\texorpdfstring{\MakeUppercase{#1}}{#1}}{Pocket}}
	\fi
	\addtocontents{toc}{\protect\addvspace{\tocspacing\p@}}
	\ifloftspace
		\addtocontents{lof}{\protect\addvspace{\loftspacing\p@}}
		\addtocontents{lot}{\protect\addvspace{\loftspacing\p@}}
	\fi
}

\newcommand{\highlight}[1]{%
	\ifdraft%
		\hl{#1}%
	\else%
		#1%
	\fi%
}

%This is a dummy command defined to improve hyperref compatibility.
\newcommand{\texorpdfstring}[2]{
	#1
}

%%%%%%%%%%%%%%%%%%%%%
% General Formating Declarations
%%%%%%%%%%%%%%%%%%%%%
\geometry{
	letterpaper,
	margin=1in,
	left=\@margg,
	headsep=0.4in,
	headheight=14pt,
	footskip=30pt,
	marginparwidth=40pt,
	marginparsep=10pt}
	
\setcounter{secnumdepth}{\value{secnumdefault}}
\setcounter{tocdepth}{\value{secnumdepth}}
\raggedbottom
\raggedright
\parindent=1.5em\relax
\markboth{}{}
\clubpenalty=10000
\widowpenalty=10000

\def\verbatim@font{\rmfamily}

\def\setspace@size{%
	\ifx \@currsize \normalsize
		\@normalsize
	\else
		\@currsize
	\fi
}

\def\doublespacing{%
	\ifcase \@ptsize \relax
		\def\baselinestretch{1.667}
	\or
		\def\baselinestretch{1.618}
	\or
		\def\baselinestretch{1.655}
	\fi
	\setspace@size
}

\def\onehalfspacing{%
	\ifcase \@ptsize \relax
		\def\baselinestretch{1.25}
	\or
		\def\baselinestretch{1.213}
	\or
		\def\baselinestretch{1.241}
	\fi
	\setspace@size
}

\def\singlespacing{%
	\def\baselinestretch{1}
	\setspace@size
	\vskip \baselineskip
}

\newcommand*\tocspacing{6}
\newcommand*\loftspacing{10}

%%%%%%%%%%%%%%%%%%%%%
% Header Formatting Declarations
%%%%%%%%%%%%%%%%%%%%%
\setcounter{part}{1}

\newcommand*\chaptersize{\normalsize}	

\newlength{\sectionpost}
\newlength{\subsectionpost}
\newlength{\subsubsectionpost}
\newlength{\paragraphpost}
\newlength{\subparagraphpost}
\newdimen\headindent
\headindent=1.5em
\ifcase\value{head}
	%---APA Style Headings---
	\newcommand*{\sectionstyle}{\bfseries\centering}
	\setlength{\sectionpost}{1.5ex \@plus .2ex}
	\newcommand*{\subsectionstyle}{\bfseries}
	\setlength{\subsectionpost}{.3ex \@plus .2ex}
	\newcommand*{\subsubsectionstyle}{\bfseries}
	\setlength{\subsubsectionpost}{-1em}
	\newcommand*{\paragraphstyle}{\hspace{2\headindent}\bfseries\underline}
	\setlength{\paragraphpost}{-1em}
	\newcommand*{\subparagraphstyle}{\hspace{3\headindent}\underline}
	\setlength{\subparagraphpost}{-1em}
\or
	%---Chicago Style Headings---
	\newcommand*{\sectionstyle}{\bfseries\centering}
	\setlength{\sectionpost}{1.5ex \@plus .2ex}
	\newcommand*{\subsectionstyle}{\centering}
	\setlength{\subsectionpost}{.3ex \@plus .2ex}
	\newcommand*{\subsubsectionstyle}{\bfseries}
	\setlength{\subsubsectionpost}{.2ex \@plus .1ex}
	\newcommand*{\paragraphstyle}{}
	\setlength{\paragraphpost}{.2ex \@plus .1ex}
	\newcommand*{\subparagraphstyle}{\hspace{\headindent}\bfseries}
	\setlength{\subparagraphpost}{-1em}
\or
	%---Sample Headings from Guidelines
	\newcommand*{\sectionstyle}{\bfseries\underline\centering}
	\setlength{\sectionpost}{1.5ex \@plus .2ex}
	\newcommand*{\subsectionstyle}{\bfseries}
	\setlength{\subsectionpost}{.3ex \@plus .2ex}
	\newcommand*{\subsubsectionstyle}{\bfseries\underline}
	\setlength{\subsubsectionpost}{-1em}
	\newcommand*{\paragraphstyle}{\hspace{\headindent}\underline}
	\setlength{\paragraphpost}{-1em}
	\newcommand*{\subparagraphstyle}{\hspace{\headindent}\bfseries}
	\setlength{\subparagraphpost}{-1em}
\or
	%---Indented Decimal System
	\newcommand*{\sectionstyle}{\bfseries}
	\setlength{\sectionpost}{1.5ex \@plus .2ex}
	\newcommand*{\subsectionstyle}{\hspace{\headindent}\bfseries}
	\setlength{\subsectionpost}{.3ex \@plus .2ex}
	\newcommand*{\subsubsectionstyle}{\hspace{2\headindent}\bfseries}
	\setlength{\subsubsectionpost}{.2ex \@plus .1ex}
	\newcommand*{\paragraphstyle}{\hspace{3\headindent}\bfseries}
	\setlength{\paragraphpost}{-1em}
	\newcommand*{\subparagraphstyle}{\hspace{4\headindent}\underline}
	\setlength{\subparagraphpost}{-1em}
\else
	%---Justified Decimal---
	\newcommand*{\sectionstyle}{\bfseries}
	\setlength{\sectionpost}{1.5ex \@plus .2ex}
	\newcommand*{\subsectionstyle}{\bfseries}
	\setlength{\subsectionpost}{.3ex \@plus .2ex}
	\newcommand*{\subsubsectionstyle}{\bfseries}
	\setlength{\subsubsectionpost}{.2ex \@plus .1ex}
	\newcommand*{\paragraphstyle}{\bfseries}
	\setlength{\paragraphpost}{-1em}
	\newcommand*{\subparagraphstyle}{\hspace{\parindent}\underline}
	\setlength{\subparagraphpost}{-1em}
\fi

\def\@chapter[#1]#2{%
	\ifnum \c@secnumdepth >\m@ne
		\refstepcounter{chapter}
		\stepcounter{partlength}
		\ifcase\value{partlength}\or
			\edef\@ChapListEnd{\thechapter}
		\or
			\edef\@ChapListStart{\@ChapListEnd}
			\edef\@ChapListEnd{\thechapter}
		\else
			\let\temp\@ChapListStart
			\edef\@ChapListStart{\temp, \@ChapListEnd}
			\edef\@ChapListEnd{\thechapter}
		\fi
		\typeout{*** \@chapapp\space\thechapter\space ****}
		\addtocontents{toc}{\protect\pagebreak[3]}
		\def\@LastLevel{0}
		\addcontentsline{toc}{chapter}{\protect\numberline{\thechapter.}\space\texorpdfstring{\MakeUppercase{#1}}{#1}}
		\ifnum\value{part}>1
			\addtocontents{toc2}{\protect\pagebreak[3]}
			\def\@LastLevel{0}
			\addcontentsline{toc2}{chapter}{\protect\numberline{\thechapter.}\space\texorpdfstring{\MakeUppercase{#1}}{#1}}
		\fi
	\else
		\addtocontents{toc}{\protect\pagebreak[3]}
		\def\@LastLevel{0}
		\addcontentsline{toc}{chapter}{#1}
		\ifnum\value{part}>1
			\addtocontents{toc2}{\protect\pagebreak[3]}
			\def\@LastLevel{0}
			\addcontentsline{toc2}{chapter}{#1}
		\fi
	\fi
	\chaptermark{#1}
	\addtocontents{toc}{\protect\addvspace{\tocspacing\p@}}
	\ifnum\value{part}>1
		\addtocontents{toc2}{\protect\addvspace{\tocspacing\p@}}
	\fi
	\ifloftspace
		\addtocontents{lof}{\protect\addvspace{\loftspacing\p@}}
		\addtocontents{lot}{\protect\addvspace{\loftspacing\p@}}
		\ifnum\value{part}>1
			\addtocontents{lof2}{\protect\addvspace{\loftspacing\p@}}
			\addtocontents{lot2}{\protect\addvspace{\loftspacing\p@}}
		\fi
	\fi
	\@makechapterhead{#2}
}

\def\@makechapterhead#1{%
	\cleardoublepage
	\vspace*{0\p@}
	{\parindent \z@ \raggedright \centering\normalfont\chaptersize
		\ifnum \c@secnumdepth >\m@ne
			\bfseries \chaptername\ \thechapter
			\vskip -3pt
		\fi
		\interlinepenalty\@M
		\bfseries\texorpdfstring{\MakeUppercase{#1}}{#1}\par\nobreak
		\vskip 15\p@
	}
}

\def\@makeschapterhead#1{%
	\cleardoublepage
	\vspace*{0\p@}
	{\parindent \z@ \raggedright \centering\normalfont\chaptersize
		\interlinepenalty\@M
		\bfseries #1\par\nobreak
		\vskip 15\p@
	}
}

\renewcommand\part{
	\cleardoublepage
	\thispagestyle{plain}%
	\global\@topnum\z@
	 \@afterindentfalse
	\secdef\@part\@spart}

\def\@part[#1]#2{
	\immediate\write\@auxout{\string\gdef\string\@FirstLength{\thepartlength}}
	\stepcounter{part}
	\ifnum\value{part}>2
		\ClassError{maine-thesis}{\protect\part command appears more than once.\MessageBreak
		A thesis cannot have more than 2 volumes.}
	\fi
	\addtocontents{toc}{\protect\pagebreak[3]}
	\def\@LastLevel{-1}
	\addcontentsline{toc}{part}{\partname\ \protect\numberline{\thepart}}	
	\immediate\write\@auxout{\string\gdef\string\@NumParts{2}}			
	\immediate\write\@auxout{\string\gdef\string\@FirstListStart{\@ChapListStart}}
	\immediate\write\@auxout{\string\gdef\string\@FirstListEnd{\@ChapListEnd}}
	\def\@ChapListStart{}
	\def\@ChapListEnd{}
	\titlepage
}

%In order to support multi-volume theses it was necessary to redefine \@sect to include the necessary code to create toc entries in the later volumes. (i.e. the contents of the \ifnum\value{part}>1 statements)
\def\@sect#1#2#3#4#5#6[#7]#8{
	\ifnum #2>\c@secnumdepth 
		\let \@svsec \@empty 
	\else 
		\refstepcounter {#1}\protected@edef \@svsec {\@seccntformat {#1}\relax }
	\fi
	\@tempskipa #5\relax 
	\ifdim \@tempskipa >\z@ 
		\begingroup #6{\@hangfrom {\hskip #3\relax \@svsec }\interlinepenalty \@M #8\@@par }
		\endgroup \csname #1mark\endcsname {#7}
		\ifnum #2 >\@LastLevel
			\addtocontents{toc}{\protect\nopagebreak}
		\fi
		\ifnum #2<\@LastLevel
			\addtocontents{toc}{\protect\pagebreak[3]}
		\fi
		\addcontentsline {toc}{#1}{%
			\ifnum #2>\c@secnumdepth 
			\else
				\protect \numberline {\csname the#1\endcsname }
			\fi
			#7}
		\ifnum\value{part}>1
			\ifnum #2 >\@LastLevel
				\addtocontents{toc2}{\protect\nopagebreak}
			\fi
			\ifnum #2<\@LastLevel
				\addtocontents{toc2}{\protect\pagebreak[3]}
			\fi
			\addcontentsline {toc2}{#1}{%
				\ifnum #2>\c@secnumdepth 
				\else
					\protect \numberline {\csname the#1\endcsname }
				\fi
				#7}
		\fi
	\else
		\def \@svsechd {#6{\hskip #3\relax \@svsec #8}\csname #1mark\endcsname {#7}
		\addcontentsline {toc}{#1}{%
			\ifnum #2>\c@secnumdepth 
			\else 
				\protect \numberline {\csname the#1\endcsname }
			\fi
			#7}
		\ifnum\value{part}>2
			\addcontentsline {toc2}{#1}{%
				\ifnum #2>\c@secnumdepth 
				\else 
					\protect \numberline {\csname the#1\endcsname }
				\fi
				#7}
		\fi
	}
	\fi
	\@xsect {#5}
	\edef\@LastLevel{#2}
}

\renewcommand\section{
	\@startsection{section}{1}{\z@}%
	{3.5ex \@plus 1ex \@minus .2ex}%
	{\sectionpost}%
	{\sectionstyle}}

\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
	{3.25ex \@plus 1ex \@minus .2ex}%
	{\subsectionpost}%
	{\subsectionstyle}}

\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
	{3.25ex \@plus 1ex \@minus .2ex}%
	{\subsubsectionpost}%
	{\subsubsectionstyle}}

\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
	{3.25ex \@plus1ex \@minus.2ex}%
	{\paragraphpost}%
	{\paragraphstyle}}

\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\z@}%	
	{3.25ex \@plus1ex \@minus .2ex}%	
	{\subparagraphpost}%
	{\subparagraphstyle}}

\def\app@chapter[#1]#2{%
	\ifmultipleappendices
		\ifnum \c@secnumdepth >\m@ne
			\refstepcounter{chapter}
			\typeout{<---- Appendix \thechapter ---->}
			\addcontentsline{toc}{chapter}{\AppendixName\space\thechapter\space -- \texorpdfstring{\MakeUppercase{#1}}{#1}}
			\ifnum\value{part}>1
				\addcontentsline{toc2}{chapter}{\AppendixName\space\thechapter\space -- \texorpdfstring{\MakeUppercase{#1}}{#1}}
			\fi
		\else
			\addcontentsline{toc}{chapter}{\texorpdfstring{\MakeUppercase{#1}}{#1}}
			\ifnum\value{part}>1
				\addcontentsline{toc2}{chapter}{\texorpdfstring{\MakeUppercase{#1}}{#1}}
			\fi
		\fi
	\else
		\ifnum \c@secnumdepth >\m@ne
			\refstepcounter{chapter}
			\typeout{<---- APPENDIX ---->}%
			\addcontentsline{toc}{chapter}{\AppendixName\space -- \texorpdfstring{\MakeUppercase{#1}}{#1}}
			\ifnum\value{part}>1
				\addcontentsline{toc2}{chapter}{\AppendixName\space -- \texorpdfstring{\MakeUppercase{#1}}{#1}}
			\fi
		\else
			\addcontentsline{toc}{chapter}{\texorpdfstring{\MakeUppercase{#1}}{#1}}
			\ifnum\value{part}>1
				\addcontentsline{toc2}{chapter}{\texorpdfstring{\MakeUppercase{#1}}{#1}}
			\fi
		\fi
	   \fi
	\addtocontents{toc}{\protect\addvspace{\tocspacing\p@}}
	\addtocontents{lof}{\protect\addvspace{\loftspacing\p@}}
	\addtocontents{lot}{\protect\addvspace{\loftspacing\p@}}
	\ifnum\value{part}>1
		\addtocontents{toc2}{\protect\addvspace{\tocspacing\p@}}
		\addtocontents{lof2}{\protect\addvspace{\loftspacing\p@}}
		\addtocontents{lot2}{\protect\addvspace{\loftspacing\p@}}
	\fi
	\chaptermark{#1}
	\@makeapphead{#2}
	\@afterheading
}

\def\@makeapphead#1{%
	\cleardoublepage
	{\vspace*{0\p@}
		\parindent \z@ \raggedright \normalfont
		\ifmultipleappendices
			\centering\chaptersize\bfseries \appendixname\space\thechapter
		\else
			\centering\chaptersize\bfseries \AppendixName
		\fi
		\par\nobreak
		\interlinepenalty\@M
		\centering\chaptersize\bfseries\texorpdfstring{\MakeUppercase{#1}}{#1}\par\nobreak
		\vskip 15\p@
	}
}

\setcounter{topnumber}{2}
\renewcommand\topfraction{0.8}
\setcounter{bottomnumber}{2}
\renewcommand\bottomfraction{0.8}
\setcounter{totalnumber}{4}
\renewcommand\textfraction{0.2}
\renewcommand\floatpagefraction{0.8}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{0.8}
\renewcommand\dblfloatpagefraction{0.8}

%%%%%%%%%%%%%%%%%%%%%
% Float Formatting Declarations
%%%%%%%%%%%%%%%%%%%%%
\let\latex@xfloat=\@xfloat
\def\@xfloat#1[#2]{%
	\latex@xfloat#1[#2]
	\centering
	\def\baselinestretch{1}\@normalsize
	\normalsize
}

\long\def\@makecaption#1#2{%
	\vskip\abovecaptionskip
	\sbox\@tempboxa{#1.~~#2}%
	\ifdim \wd\@tempboxa >\hsize
		{#1.~~#2}\par%
	\else
		\global \@minipagefalse
		\hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
	\fi
	\vskip\belowcaptionskip
}

\long\def\@caption#1[#2]#3{%
	\ifmt@legacycaptions%
		\def\mt@captiontext{#3}%.
	\else%
		\IfStrEq{#2}{#3}{\def\mt@captiontext{#3}}{\def\mt@captiontext{#2\ \ignorespaces#3}}%
	\fi%
	\addcontentsline{\csname ext@#1\endcsname}{#1}	{\protect\numberline{\csname fnum@#1\endcsname}{\ignorespaces #2}}%
	\ifnum\value{part}>1
		\addcontentsline{\csname ext@#1 2\endcsname}{#1}	{\protect\numberline{\csname fnum@#1\endcsname}{\ignorespaces #2}}%
	\fi
	\begingroup
	\@parboxrestore
	\normalsize
	\centering
	\@makecaption{\csname fnum@#1\endcsname}{\ignorespaces\mt@captiontext}\par
	\endgroup
}

\long\def\@footnotetext#1{%
	\insert\footins{%
		\def\baselinestretch {1}
		\reset@font\footnotesize
		\interlinepenalty\interfootnotelinepenalty
		\splittopskip\footnotesep
		\splitmaxdepth \dp\strutbox \floatingpenalty \@MM
		\hsize\columnwidth
		\@parboxrestore
		\protected@edef\@currentlabel{%
			\csname p@footnote\endcsname\@thefnmark}%
		\color@begingroup
		\@makefntext{\rule\z@\footnotesep\ignorespaces#1\@finalstrut\strutbox}%
	\color@endgroup}
}

\long\def\@mpfootnotetext#1{%
	\global\setbox\@mpfootins\vbox{%
		\unvbox \@mpfootins
		\def\baselinestretch {1}
		\reset@font\footnotesize
		\hsize\columnwidth
		\@parboxrestore
		\protected@edef\@currentlabel{%
			\csname p@mpfootnote\endcsname\@thefnmark}%
		\color@begingroup
		\@makefntext{\rule\z@\footnotesep\ignorespaces#1\@finalstrut\strutbox}%
	\color@endgroup}
}

%%%%%%%%%%%%%%%%%%%%%
% Table of Contents Formatting
%%%%%%%%%%%%%%%%%%%%%
\renewcommand\tableofcontents{%
	\chapter*{\chaptersize\contentsname%
		\@mkboth{\contentsname}{\contentsname}}%
	\vskip -\tocspacing\p@
	\doublespacing
	\ifnum\value{part}=1
		\@starttoc{toc}
	\else	
		\@starttoc{toc2}
	\fi
	\ifnum\value{part}>1
		\addtocontents{toc}{\protect\nopagebreak}
		\addcontentsline{toc}{chapter}{\contentsname}
	\fi
}

\renewcommand\listoftables{%
	\chapter*{\chaptersize\listtablename%
		\@mkboth{\listtablename}{\listtablename}}
	\addcontentsline{toc}{chapter}{\listtablename}
	\ifnum\value{part}>1
		\addcontentsline{toc2}{chapter}{\listtablename}
	\fi
	\vskip -24pt
	\vskip -\loftspacing\p@
	\doublespacing
	\setcounter{tocdepth}{\value{secnumdepth}}
	\ifnum\value{part}=1
		\@starttoc{lot}
	\else	
		\@starttoc{lot2}
	\fi
}

\renewcommand\listoffigures{%
	\chapter*{\chaptersize\listfigurename%
		\@mkboth{\listfigurename}{\listfigurename}}
	\addcontentsline{toc}{chapter}{\listfigurename}
	\ifnum\value{part}>1
		\addcontentsline{toc2}{chapter}{\listfigurename}
	\fi
	\vskip -24pt
	\vskip -\loftspacing\p@
	\doublespacing
	\setcounter{tocdepth}{\value{secnumdepth}}
	\ifnum\value{part}=1
		\@starttoc{lof}
	\else
		\@starttoc{lof2}
	\fi
}

\newenvironment{thesislist}[1]{%
	\chapter*{LIST OF \texorpdfstring{\MakeUppercase{#1}}{#1}}
	\addcontentsline{toc}{chapter}{{\listname\ \texorpdfstring{\MakeUppercase{#1}}{#1}}}
	\ifnum\value{part}>1
		\addcontentsline{toc2}{chapter}{{\listname\ \texorpdfstring{\MakeUppercase{#1}}{#1}}}
	\fi
	\begingroup
}{\par\endgroup}

\renewcommand\@dotsep{1}
\renewcommand\@tocrmarg{4em}
\renewcommand\@pnumwidth{1.4em}
\patchcmd{\@dottedtocline}%
	{\rightskip\@tocrmarg}%
	{\rightskip\@tocrmarg plus 4em \hyphenpenalty\@M}%
	{%
		\patchcmd{\@dottedtocline}{\hfill}{\hskip 9.3mm plus1fill}{\typeout{5-dot minimum leader patched}}{}%
	}%
	{\ClassErrorNoLine{maine-thesis}{Unable to patch \protect\@dottedtocline\MessageBreak 5-dot leader minimum will not be respected}}

%We use this count to prevent a page break between two toc entries when the second is one level lower than the first.
\newcount\mt@lasttocentry
\mt@lasttocentry=0
%This if is supposed to keep the first two entries at a level together.
\newif\ifmt@isfirst
\mt@isfirsttrue

\renewcommand*\l@part[2]{%
	\addpenalty{-\@highpenalty}%
	\addvspace{2.25em \@plus\p@}%
	\setlength\@tempdima{3em}%
	\begingroup
		\pagebreak[3]
		\parindent \z@ \rightskip \@pnumwidth
		\parfillskip -\@pnumwidth
		{\leavevmode
		#1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
		\nobreak
			\global\@nobreaktrue
			\everypar{\global\@nobreakfalse\everypar{}}%
	\endgroup
	\mt@lasttocentry=0
}
\renewcommand*\l@chapter{%
	\ifnum\mt@lasttocentry=0\relax%
		\nopagebreak%
		\mt@isfirsttrue%
	\else%
		\ifmt@isfirst\nopagebreak\fi%
		\mt@isfirstfalse%
	\fi%
	\mt@lasttocentry=1%
	\vskip 12pt plus 1pt minus 1pt%
	\@dottedtocline{0}{0em}{1.4em}}
\renewcommand*\l@section{%
	\ifnum\mt@lasttocentry=1\relax%
		\nopagebreak%
		\mt@isfirsttrue%
	\else%
		\ifmt@isfirst\nopagebreak\fi%
		\mt@isfirstfalse%
	\fi%
	\mt@lasttocentry=2%
	\ifnum\c@tocdepth>0 \vskip 5pt plus 1pt minus 1pt \fi%
	\@dottedtocline{1}{1.5em}{2.3em}}
\renewcommand*\l@subsection{%
	\ifnum\mt@lasttocentry=2\relax%
		\nopagebreak%
		\mt@isfirsttrue%
	\else%
		\ifmt@isfirst\nopagebreak\fi%
		\mt@isfirstfalse%
	\fi%
	\mt@lasttocentry=3%
	\ifnum\c@tocdepth>1 \vskip 4pt minus 1pt \fi%
	\@dottedtocline{2}{3.8em}{3.2em}}
\renewcommand*\l@subsubsection{%
	\ifnum\mt@lasttocentry=3\relax%
		\nopagebreak%
		\mt@isfirsttrue%
	\else%
		\ifmt@isfirst\nopagebreak\fi%
		\mt@isfirstfalse%
	\fi%
	\mt@lasttocentry=4%
	\ifnum\c@tocdepth>2 \vskip 3pt minus 1pt \fi%
	\@dottedtocline{3}{7.0em}{4.1em}}
\renewcommand*\l@figure{%
	\vskip 8pt plus 1pt minus 1pt%
	\@dottedtocline{1}{0em}{5.8em}}
\let\l@table\l@figure
\newcommand{\bibalign}{}

%%%%%%%%%%%%%%%%%%%%%
% Special Pages/Environments
%%%%%%%%%%%%%%%%%%%%%
\newcommand{\references}{%
	\cleardoublepage
	\singlespacing
	\addcontentsline{toc}{chapter}{{\@bibtitle}}
	\ifnum\value{part}>1
		\addcontentsline{toc2}{chapter}{{\@bibtitle}}
	\fi
	\bibliography{\@bibfiles}
}

\renewenvironment{thebibliography}[1]
	{\chapter*{\@bibtitle}
		\bibalign\frenchspacing
		\list{\@biblabel{\@arabic\c@enumiv}}%
			{\settowidth\labelwidth{\@biblabel{#1}}%
				\leftmargin\labelwidth
				\advance\leftmargin\labelsep
				\@openbib@code
				\usecounter{enumiv}
				\let\p@enumiv\@empty
				\renewcommand\theenumiv{\@arabic\c@enumiv}}%
		\sloppy
	\sfcode`\.=\@m}
	{\def\@noitemerr
		{\@latex@warning{Empty `thebibliography' environment}}%
	\endlist}

\renewcommand\titlepage{%
	\ifnum\value{part}>1
		\relax
	\else
		\thispagestyle{empty}
	\fi
	\ifverybigtitlepage
		\onehalfspacing
	\else
		\doublespacing
	\fi
	\begin{center}
	{\bfseries\MakeUppercase{\@title}}\\
	\ifcase\@NumParts\or
		\relax
	\or
		\textbf{\partname\ \thepart\ %
		\ifnum\value{part}>1%
			\ifcase\@LastLength\or%
				(\chaptername\ \@LastListEnd)%
			\or%
				(\chapternamep\ \@LastListStart\ and \@LastListEnd)%
			\else%
				(\chapternamep\ \@LastListStart, and \@LastListEnd)%
			\fi%
		\else%
			\ifcase\@FirstLength\or%
				(\chaptername\ \@FirstListEnd)%
			\or%
				(\chapternamep\ \@FirstListStart\ and \@FirstListEnd)%
			\else%
				(\chapternamep\ \@FirstListStart, and \@FirstListEnd)%
			\fi%
		\fi%
		}\\
	\fi
	By \\
	\@author \\
	\@degreesheld
	\vfill
	A \@type\\[4pt]
	Submitted in Partial Fulfillment of the\\
	Requirements for the Degree of\\
	\expandafter{\@degree}\\
	(in \expandafter{\@program})\\
	\vskip 0.5in
	The Graduate School\\
	The University of Maine\\
	\expandafter{\@submitdate}
	\vfill
	\end{center}
	\ifbigtitlepage
		\singlespacing
	\fi
	Advisory Committee:
	\begin{list}{}{%
		\setlength{\itemsep}{0pt}%
		\setlength{\topsep}{0in}%
		\setlength{\partopsep}{0pt}%
		\setlength{\itemindent}{-\parindent}%
		\setlength{\leftmargin}{1cm}%
		}
	\item{\@principaladvisor, %
		\ifnum\numadv=2%
			Co-%
		\fi%
		Advisor}
	\ifnum\numadv=2
		\item{\@secondadvisor, Co-Advisor}
	\fi
	\ifnum\numcomm>0
		\item{\@firstreader}
	\fi
	\ifnum\numcomm>1
		\item{\@secondreader}
	\fi
	\ifnum\numcomm>2
		\item{\@thirdreader}
	\fi
	\ifnum\numcomm>3
		\item{\@fourthreader}
	\fi
	\ifnum\numcomm>4
		\item{\@fifthreader}
	\fi
	\end{list}
	\clearpage
}

\newcommand{\copyrightpage}[2][\@author]{%
	\copyrightpagetrue
	\onehalfspacing
	\thispagestyle{plain}
	\hbox{ }
	\vfill
	\begin{center}
	\copyright\space#2\space#1\\
	All Rights Reserved
	\end{center}
	\vfill
	\clearpage
}

\newcommand{\libraryrights}{%
	\ClassError{maine-thesis}{The Graduate School no longer requires\MessageBreak a Library Rights Statement page}{Please remove \protect\libraryrights\space from your thesis.}%
}

\newcommand{\dissacceptance}{%
	\ClassError{maine-thesis}{The Graduate School no longer requires\MessageBreak a Dissertation Acceptance page}{Please remove \protect\dissacceptance\space from your thesis.}%
}

\renewenvironment{abstract}{%
	\doublespacing
	\begin{center}
		{\bfseries\MakeUppercase{\@title}}
		\vskip 0.5in
		By\space\@author\\[4pt]
		\@Type\ %
		\ifnum\numadv=2%
			Co-%
		\fi%
		Advisor%
		\ifnum\numadv=2%
			s%
		\fi%
		: \@principalshort
		\vskip 0.33in
		\singlespacing
		An Abstract of the \@Type\ Presented\\
		in Partial Fulfillment of the Requirements for the\\
		Degree of \@degree\\
		(in \@program)\\
		\@submitdate
		\vskip 36pt plus 2pt minus 12pt
	\end{center}
	\doublespacing
	\begingroup\par
	\pagestyle{empty}
}
{\cleardoublepage
	\par\endgroup
	\ifcopyrightpage
		\ifofficial
			\setcounter{page}{3}
		\else
			\setcounter{page}{2}
		\fi
	\else
		\ifofficial
			\setcounter{page}{2}
		\else
			\setcounter{page}{1}
		\fi
	\fi
}

\newenvironment{layabstract}[1]{%
	\doublespacing
	\begin{center}
		{\bfseries\MakeUppercase{\@title}}
		\vskip 0.5in
		By\space\@author\\[4pt]
		\@Type\ %
		\ifnum\numadv=2%
			Co-%
		\fi%
		Advisor%
		\ifnum\numadv=2%
			s%
		\fi%
		: \@principalshort
		\vskip 0.33in
		\singlespacing
		A Lay Abstract of the \@Type\ Presented\\
		in Partial Fulfillment of the Requirements for the\\
		Degree of \@degree\\
		(in \@program)\\
		\@submitdate
		\vskip 26pt plus 2pt minus 12pt
	\end{center}
	Keywords: \MakeLowercase{#1}
	\vskip 26pt plus 2pt minus 12pt
	\doublespacing
	\begingroup\par
	\pagestyle{empty}
}
{\cleardoublepage
	\par\endgroup
	\ifcopyrightpage
		\ifofficial
			\setcounter{page}{3}
		\else
			\setcounter{page}{2}
		\fi
	\else
		\ifofficial
			\setcounter{page}{2}
		\else
			\setcounter{page}{1}
		\fi
	\fi
}

\newenvironment{dedication}{%
	\chapter*{DEDICATION}
	\addcontentsline{toc}{chapter}{DEDICATION}
	\vskip 0.5in
	\doublespacing
	\begingroup
	\begin{center}
}{\end{center}\par\endgroup}

\newenvironment{acknowledgements}{%
	\chapter*{ACKNOWLEDGEMENTS}
	\addcontentsline{toc}{chapter}{{ACKNOWLEDGEMENTS}}
	\doublespacing
	\begingroup
}{\par\endgroup}

\newenvironment{preface}{%
	\chapter*{PREFACE}
	\addcontentsline{toc}{chapter}{{PREFACE}}
	\doublespacing
	\begingroup\setcounter{secnumdepth}{0}
}{\setcounter{secnumdepth}{\value{secnumdefault}}\par\endgroup}

\newenvironment{biography}{%
	\chapter*{BIOGRAPHY OF THE AUTHOR}
	\addtocontents{toc}{\protect\nopagebreak}
	\addcontentsline{toc}{chapter}{BIOGRAPHY OF THE AUTHOR}
	\ifnum\value{part}>1
		\addtocontents{toc2}{\protect\nopagebreak}
		\addcontentsline{toc2}{chapter}{BIOGRAPHY OF THE AUTHOR}
	\fi
	\begingroup
	\doublespacing
	\thispagestyle{plain}
}{\ifx\@authorpronoun\empty\@author\else\@authorpronoun\fi\ is a candidate for the \@degree\ degree in \@program\ from The University of Maine in \@submitdate.\par\endgroup}

%%%%%%%%%%%%%%%%%%%%%
% Front/Main/Back Separators
%%%%%%%%%%%%%%%%%%%%%
\newcommand{\preliminary}{%
	\pagestyle{plain}
	\pagenumbering{roman}
	\settocdepth{chapter}
}

\newcommand{\mainmatter}[1]{%
	\cleardoublepage
	\doublespacing
	\pagestyle{#1}
	\pagenumbering{arabic}
	\toclabel{\chaptername}
	\ifcase\value{secnumdepth}
		\settocdepth{chapter}
	\or
		\settocdepth{section}
	\or
		\settocdepth{subsection}
	\or
		\settocdepth{subsubsection}
	\or
		\settocdepth{paragraph}
	\or
		\settocdepth{subparagraph}
	\fi
}

\renewcommand{\appendix}{%
	\immediate\write\@auxout{\string\gdef\string\@LastListStart{\@ChapListStart}}
	\immediate\write\@auxout{\string\gdef\string\@LastListEnd{\@ChapListEnd}}
	\immediate\write\@auxout{\string\gdef\string\@LastLength{\thepartlength}}
	\setcounter{chapter}{0}
	\setcounter{section}{0}
	\renewcommand*\@chapter{\app@chapter}
	\renewcommand*\thechapter{\@Alph\c@chapter}
	\addtocontents{toc}{\protect\renewcommand*\protect\l@chapter{\protect\@dottedtocline{0}{0pt}{7.5em}}}
	\settocdepth{chapter}
	\ifnum\value{part}>1
		\addtocontents{toc2}{\setcounter{tocdepth}{0}}
		\addtocontents{toc2}{\protect\renewcommand*\protect\l@chapter{\protect\@dottedtocline{0}{0pt}{7.5em}}}
	\fi
	\doublespacing
	\apptrue
}

%%%%%%%%%%%%%%%%%%%%%
% Page Style Definitions
%%%%%%%%%%%%%%%%%%%%%

\newcommand{\ps@bottom}{%
	\let\@mkboth\markboth
	\renewcommand{\@oddhead}{%
		\ifdraft\drafttext\hfil\today\hfil\drafttext\else\fi}%
	\renewcommand{\@evenhead}{\@oddhead}
	\renewcommand{\@oddfoot}{%
		\ifdraft\drafttext\hfil\thepage
		\hfil\drafttext\else\hfil\thepage\hfil\fi}
	\renewcommand{\@evenfoot}{\@oddfoot}
}

\renewcommand{\ps@plain}{\ps@bottom}

\renewcommand{\ps@empty}{%
	\let\@mkboth\markboth
	\renewcommand{\@oddhead}{%
		\ifdraft\drafttext\hfil\today\hfil\drafttext\else\fi}%
	\renewcommand{\@evenhead}{\@oddhead}
	\renewcommand{\@oddfoot}{%
		\ifdraft\drafttext\hfil\drafttext\else\fi}
	\renewcommand{\@evenfoot}{\@oddfoot}
}

\newcommand{\ps@top}{%
	\let\@mkboth\markboth
	\renewcommand{\@oddhead}{%
		\ifdraft\drafttext\fi\hfil
		\ifdraft\today\else\thepage\fi
		\ifdraft\hfil\drafttext\fi}
	\renewcommand{\@evenhead}{%
		\ifdraft\drafttext\hfil\fi
		\ifdraft\today\else\thepage\fi
		\hfil\ifdraft\drafttext\fi}	
	\renewcommand{\@oddfoot}{%
		\ifdraft\drafttext\hfil\thepage\hfil\drafttext\fi}
	\renewcommand{\@evenfoot}{\@oddfoot}
}


\endinput
%%
%% End of file `maine-thesis.cls'.
