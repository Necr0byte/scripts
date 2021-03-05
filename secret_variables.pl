#!/usr/bin/perl
use warnings;

my $environment = "QA";
my $namespace = "financial";
my $project = "ms-service-payments";
my $numArgs = $#ARGV + 1;

print "Use this in Find and Replace secrets: \n \n";
print "cat secrets.properties\n";
print "sed -i 's/{app-insights-instrumentationKey-QA}/\$(app-insights-instrumentationKey-QA)/g' secrets.properties\n";

foreach my $argnum (0 .. $#ARGV) {
    my $variable = $ARGV[$argnum];
    print "sed -i 's/{$variable-$environment}/\$($variable-$environment)/g' secrets.properties\n";
}
print "cat secrets.properties\n \n";

print "Use this in Create/update secrets: \n \n";

print "#!/bin/bash \n";
print "if [[ \$(kubectl get secret -n $namespace | grep $project) == \"\" ]] ; then \n";
print "echo \"create secret\"\n";
print "kubectl create secret generic $project --from-env-file=./secrets.properties -n $namespace \n";
print "else \n";
print "echo \"update secret\"\n";
print "kubectl create secret generic $project --from-env-file=./secrets.properties -o yaml --dry-run | kubectl  -n $namespace replace -f - \n";
print "fi\n\n";

print "Add this to your secrets.config file:\n\n";

print "APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey={app-insights-instrumentationKey-$environment}\n";
foreach my $argnum (0 .. $#ARGV) {
    my $variable = $ARGV[$argnum];
    print "$variable={$variable-$environment}\n";
}
print "\n\n That's it. \n";
