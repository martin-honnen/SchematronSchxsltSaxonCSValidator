using Org.XmlResolver;
using Org.XmlResolver.Utils;
using Saxon.Api;
using System.Diagnostics;
using System.Reflection;
using System.Xml;

Console.WriteLine($"Schematron Schxslt Validator using Schxslt 1.9.5 and SaxonCS 12.3 under {Environment.Version} {Environment.OSVersion}");

if (args.Length != 2)
{
    Console.WriteLine($"Usage: SchematronSchxsltSaxonCSValidator schema.sch input.xml");
    return;
}

var stopWatch = new Stopwatch();
stopWatch.Start();

string schxsltSvrlXsltResource = @"SchematronSchxsltSaxonCSValidator/schxslt195/pipeline-for-svrl.xsl";

var schxsltResourceUri = UriUtils.GetLocationUri(schxsltSvrlXsltResource, Assembly.GetExecutingAssembly());

var resolver = new Resolver();

var settings = new XmlReaderSettings() { XmlResolver = resolver };

var processor = new Processor(true);

var xsltCompiler = processor.NewXsltCompiler();

using var schxsltReader = XmlReader.Create(schxsltResourceUri.AbsoluteUri, settings);

var compiledSchxslt = xsltCompiler.Compile(schxsltReader).Load30();

var compiledSchematron = new XdmDestination();
compiledSchematron.BaseUri = new Uri(new FileInfo(args[0]).FullName);

using var schemaStream = File.OpenRead(args[0]); 
compiledSchxslt.Transform(schemaStream, compiledSchematron);

var xsltCompiler2 = processor.NewXsltCompiler();

var schematronValidator = xsltCompiler2.Compile(compiledSchematron.XdmNode).Load30();

var svrlResult = new XdmDestination();

using var instanceStream = File.OpenRead(args[1]);
schematronValidator.Transform(instanceStream, new Uri(new FileInfo(args[1]).FullName), svrlResult);

var valid = (processor.NewXPathCompiler().EvaluateSingle("not((/Q{http://purl.oclc.org/dsdl/svrl}schematron-output!(Q{http://purl.oclc.org/dsdl/svrl}failed-assert)))", svrlResult.XdmNode) as XdmAtomicValue).AsBoolean();

Console.WriteLine($"XML document {args[1]} is {(valid ? "" : "not ")}valid against Schematron schema {args[0]}.");

if (!valid)
{
    Console.WriteLine($"{Environment.NewLine}Validation report:{Environment.NewLine}{svrlResult.XdmNode}");
}

stopWatch.Stop();

Console.WriteLine($"Elapsed time: {stopWatch.Elapsed}");
