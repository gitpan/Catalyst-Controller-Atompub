use strict;
use warnings;
use Data::Dumper; $Data::Dumper::Indent = 1;
use Test::More tests => 24;

use Atompub::Client;
use Atompub::DateTime qw(datetime);
use File::Slurp;
use FindBin;
use HTTP::Status;
use XML::Atom::Entry;

#system "sqlite3 $FindBin::Bin/../test.db < $FindBin::Bin/../init.sql";

access_as(qw(foo foo));
access_as(qw(bar bar));
access_as_anonymous(qw(foo bar));

sub access_as {
    my($username, $password) = @_;

    my $client = Atompub::Client->new;
    $client->username($username);
    $client->password($password);

    my $service = $client->getService('http://localhost:3000/service');
    isa_ok $service, 'XML::Atom::Service';
    is my @work = $service->workspaces, 1;
    is my @coll = $work[0]->collections, 1;
    is $coll[0]->href, "http://localhost:3000/collection/$username";

    my $entry = XML::Atom::Entry->new;
    $entry->title('Entry 1');
    $entry->content('This is the 1st entry');
    ok my $uri = $client->createEntry("http://localhost:3000/collection/$username", $entry, 'Entry 1');
    is $uri, "http://localhost:3000/collection/$username/entry_1.atom";

    ok my $feed = $client->getFeed("http://localhost:3000/collection/$username");
    is my @entries = $feed->entries, 1;

    ok $entry = $client->getEntry($uri);

    $entry->title('Entry 1, ver.2');
    ok $client->updateEntry($uri, $entry);

#    ok $client->deleteEntry($uri);
}

sub access_as_anonymous {
    my(@users) = @_;
    my $client = Atompub::Client->new;
    for my $username (@users) {
        ok my $feed = $client->getFeed("http://localhost:3000/collection/$username");
        is my @entries = $feed->entries, 1;
    }
}
