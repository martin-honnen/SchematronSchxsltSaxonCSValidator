# Schematron validation using SaxonCS and Schxslt
Sample .NET 6 console app that validates a provided XML instance document against a provided Schematron schema by using SaxonCS and Schxslt to transpile the Schematron to XSLT and run the created XSLT to perform the validation.

Note that SaxonCS requires a license and needs to be able to find it, for instance by setting the environment variable `SAXON_LICENSE_DIR` to the location of the license file.

This app uses the Schxslt XSLT library which is copyright (c) 2018–2021 by David Maus &lt;dmaus@dmaus.name&gt; and released under the terms of the MIT license.
