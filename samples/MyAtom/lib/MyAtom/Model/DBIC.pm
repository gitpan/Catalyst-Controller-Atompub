package # hide from PAUSE
    MyAtom::Model::DBIC;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'MyAtom::Model::Schema',
    connect_info => [
        'dbi:SQLite:dbname=atom.db',
    ],
);

1;
