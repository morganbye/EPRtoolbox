# EPRtoolbox
```
  ______ _____  _____    _               _ _
 |  ____|  __ \|  __ \  | |             | | |
 | |__  | |__) | |__) | | |_  ___   ___ | | |__   _____  __
 |  __| |  ___/|  _  /  | __|/ _ \ / _ \| | '_ \ / _ \ \/ /
 | |____| |    | | \ \  | |_| (_) | (_) | | |_) | (_) >  <
 |______|_|    |_|  \_\  \__|\___/ \___/|_|_.__/ \___/_/\_\
```


 M. Bye v18.0

# Installation
* Extract the zip folder
* Add the folder to your MATLAB path
    * From the menus select `File` -> `Set Path`
	* Navigate and select the newly extracted folder
	* Click `Add with Subfolders`
    * Click `Save`
	* Click `Close`
Type `EPRtoolbox` in the MatLab command window to start the main toolbox
Type `PowerSat` to start the power saturation tool
    (also available through the main toolbox)

# Full functionality
The toolbox contains many useful scripts that are not contained within the
main graphical user interface. Feel free to browse these at your leisure
(particularly the `misc` directory for zerofilling, noise filters, etc).

Each has an extensive help header section and will have a link to the online
help with examples of how to use the script.

# A note on user interfaces
In MatLab 2015a MathWorks (the company behind MatLab) dramatically changed the
backend to how MatLab makes and runs user interfaces. All development with the
EPRtoolbox was made in MatLab 2013a, and so the user interfaces *WILL NOT* work
with newer versions of MatLab.

This is a known problem for many developers, and I do not have the time (or the
MatLab licenses) to rebuild every user interface in the toolbox from scratch.

So I face the decision of,
1. remove all the user interfaces from the toolbox
2. leave the user interfaces in and confuse users with newer MatLab versions

As the toolbox is only in essential maintenance mode, I have elected to leave
the functionality in place so that old users and keep using the functions they
are already familiar with. Whilst I hope this notice, will alert new users of
the toolbox that not all functionality is available.

New developers can of course, branch this project and expand the functionality
to newer versions of MatLab.


# More information
## Toolbox homepage
http://morganbye.net/eprtoolbox

## Code hosting
http://github.com/morganbye/EPRtoolbox

## Version history
http://morganbye.net/eprtoolbox/version-history

## Prominent applications
### PowerSat
http://morganbye.net/PowerSat

### cwViewer
http://morganbye.net/cwViewer


# Contact me
The toolbox is now in long-term maintenance mode, however bugs should be
reported directly on github:
https://github.com/morganbye/EPRtoolbox/issues

Any problems, suggestions or contributions should be emailed to
mailto://dev@morganbye.com

Or via the contact page on the website:
http://morganbye.com/contact


# Contribute
If you spot an error - please create a bug report on github

If you'd like to contribute to the toolbox - please email

If you use the toolbox and feel like it's saved you time/effort/frustration
drop me an email to say thanks, they really mean a lot to me!

If you find the toolbox lacking feel free to fork and branch as you please.


# Acknowledgements

## Contributors
Alberto Collauto - Goethe-Universitat, Frankfurt am Main, Germany
* SpecMan file format

Frederic Mentink - National High Field Magnet Laboratory, Tallahassee, USA
* PulseGen script writer

### Testing and error reporting

* Müge Aksoyoglu - Uni. Freiburg, Germany
  * BrukerRead and PowerSat error reporting
* Ray Burton-Smith - Queen Mary, Uni. of London, UK
  * Concept development
  * Beer!
* Timothee Chauvire - ACERT, USA
  * BrukerRead error reporting
* Gunnar Jeschke - ETH Zurich, Switzerland
  * DeerAnalysis discussion
  * MMM discussion
* Peter Meadows - Jeol (UK) Ltd, UK
  * File format discussion
* Alexander Morley - Universitat Wien, Austria
  * cwViewer error reporting
  * PowerSat error reporting
* David Mulder - National Renewable Energy Laboratory, USA
  * cwViewer error reporting
  * e2af inspiration
  * Beer!
* Patrick Pennington - Dartmouth, USA
  * Concept development
* Yevhen Polyhach - ETH Zurich, Switzerland
  * MMM development
* Richard Rothery - Uni. of Alberta, Canada
  * e2a error reporting
  * BrukerRead error reporting
* Paulo Souza -  Uni. of Brasilia, Brazil
  * e2a error reporting
* Robert Usselman - Uni. of Montana, USA
  * Toolbox questions
