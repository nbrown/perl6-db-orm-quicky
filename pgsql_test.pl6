#!/usr/bin/env perl6

use lib 'lib';

use DB::ORM::Quicky;

my $orm = DB::ORM::Quicky.new;

$orm.connect(
  driver  => 'Pg', 
  options => %( 
    host     => 'localhost',
    port     => 5432,
    database => 'tony',
    user     => 'tony',
    password => '', 
  )
);

my $username = '';

$username ~= chr((65 .. 90).pick) for 0 .. 10;

$username.say;
my $newrow = $orm.create('nickl');

$newrow.set('username' => $username);
$newrow.set('password' => 'tony');
$newrow.set('joined' => time);
$newrow.save;


my $tests = $orm.search('nickl', { 
  '-and' => [
    '-raw' => ('"joined" > ? - 5000' => 50)
  ]
});

for @($tests.all) -> $user {
  say 'test1: ' ~ $user.get('username');
}

my $test2 = $orm.search('nickl', { 
  '-and' => [
    joined => ('-gt' => 50 - 5000)
  ]
});

for @($test2.all) -> $user {
  say 'test2: ' ~ $user.get('username');
}
