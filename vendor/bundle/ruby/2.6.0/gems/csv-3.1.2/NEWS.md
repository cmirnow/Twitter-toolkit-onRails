# News

## 3.1.2 - 2019-10-12

### Improvements

  * Added `:col_sep` check.
    [GitHub#94][Reported by Florent Beaurain]

  * Suppressed warnings.
    [GitHub#96][Patch by Nobuyoshi Nakada]

  * Improved documentation.
    [GitHub#101][GitHub#102][Patch by Vitor Oliveira]

### Fixes

  * Fixed a typo in documentation.
    [GitHub#95][Patch by Yuji Yaginuma]

  * Fixed a multibyte character handling bug.
    [GitHub#97][Patch by koshigoe]

  * Fixed typos in documentation.
    [GitHub#100][Patch by Vitor Oliveira]

  * Fixed a bug that seeked `StringIO` isn't accepted.
    [GitHub#98][Patch by MATSUMOTO Katsuyoshi]

  * Fixed a bug that `CSV.generate_line` doesn't work with
    `Encoding.default_internal`.
    [GitHub#105][Reported by David Rodríguez]

### Thanks

  * Florent Beaurain

  * Yuji Yaginuma

  * Nobuyoshi Nakada

  * koshigoe

  * Vitor Oliveira

  * MATSUMOTO Katsuyoshi

  * David Rodríguez

## 3.1.1 - 2019-04-26

### Improvements

  * Added documentation for `strip` option.
    [GitHub#88][Patch by hayashiyoshino]

  * Added documentation for `write_converters`, `write_nil_value` and
    `write_empty_value` options.
    [GitHub#87][Patch by Masafumi Koba]

  * Added documentation for `quote_empty` option.
    [GitHub#89][Patch by kawa\_tech]

### Fixes

  * Fixed a bug that `strip; true` removes a newline.

### Thanks

  * hayashiyoshino

  * Masafumi Koba

  * kawa\_tech

## 3.1.0 - 2019-04-17

### Fixes

  * Fixed a backward incompatibility bug that `CSV#eof?` may raises an
    error.
    [GitHub#86][Reported by krororo]

### Thanks

  * krororo

## 3.0.9 - 2019-04-15

### Fixes

  * Fixed a test for Windows.

## 3.0.8 - 2019-04-11

### Fixes

  * Fixed a bug that `strip: String` doesn't work.

## 3.0.7 - 2019-04-08

### Improvements

  * Improve parse performance 1.5x by introducing loose parser.

### Fixes

  * Fix performance regression in 3.0.5.

  * Fix a bug that `CSV#line` returns wrong value when you
    use `quote_char: nil`.

## 3.0.6 - 2019-03-30

### Improvements

  * `CSV.foreach`: Added support for `mode`.

## 3.0.5 - 2019-03-24

### Improvements

  * Added `:liberal_parsing => {backslash_quote: true}` option.
    [GitHub#74][Patch by 284km]

  * Added `:write_converters` option.
    [GitHub#73][Patch by Danillo Souza]

  * Added `:write_nil_value` option.

  * Added `:write_empty_value` option.

  * Improved invalid byte line number detection.
    [GitHub#78][Patch by Alyssa Ross]

  * Added `quote_char: nil` optimization.
    [GitHub#79][Patch by 284km]

  * Improved error message.
    [GitHub#81][Patch by Andrés Torres]

  * Improved IO-like implementation for `StringIO` data.
    [GitHub#80][Patch by Genadi Samokovarov]

  * Added `:strip` option.
    [GitHub#58]

### Fixes

  * Fixed a compatibility bug that `CSV#each` doesn't care `CSV#shift`.
    [GitHub#76][Patch by Alyssa Ross]

  * Fixed a compatibility bug that `CSV#eof?` doesn't care `CSV#each`
    and `CSV#shift`.
    [GitHub#77][Reported by Chi Leung]

  * Fixed a compatibility bug that invalid line isn't ignored.
    [GitHub#82][Reported by krororo]

  * Fixed a bug that `:skip_lines` doesn't work with multibyte characters data.
    [GitHub#83][Reported by ff2248]

### Thanks

  * Alyssa Ross

  * 284km

  * Chi Leung

  * Danillo Souza

  * Andrés Torres

  * Genadi Samokovarov

  * krororo

  * ff2248

## 3.0.4 - 2019-01-25

### Improvements

  * Removed duplicated `CSV::Row#include?` implementations.
    [GitHub#69][Patch by Max Schwenk]

  * Removed duplicated `CSV::Row#header?` implementations.
    [GitHub#70][Patch by Max Schwenk]

### Fixes

  * Fixed a typo in document.
    [GitHub#72][Patch by Artur Beljajev]

  * Fixed a compatibility bug when row headers are changed.
    [GitHub#71][Reported by tomoyuki kosaka]

### Thanks

  * Max Schwenk

  * Artur Beljajev

  * tomoyuki kosaka

## 3.0.3 - 2019-01-12

### Improvements

  * Migrated benchmark tool to benchmark-driver from benchmark-ips.
    [GitHub#57][Patch by 284km]

  * Added `liberal_parsing: {double_quote_outside_quote: true}` parse
    option.
    [GitHub#66][Reported by Watson]

  * Added `quote_empty:` write option.
    [GitHub#35][Reported by Dave Myron]

### Fixes

  * Fixed a compatibility bug that `CSV.generate` always return
    `ASCII-8BIT` encoding string.
    [GitHub#63][Patch by Watson]

  * Fixed a compatibility bug that `CSV.parse("", headers: true)`
    doesn't return `CSV::Table`.
    [GitHub#64][Reported by Watson][Patch by 284km]

  * Fixed a compatibility bug that multiple-characters column
    separator doesn't work.
    [GitHub#67][Reported by Jesse Reiss]

  * Fixed a compatibility bug that double `#each` parse twice.
    [GitHub#68][Reported by Max Schwenk]

### Thanks

  * Watson

  * 284km

  * Jesse Reiss

  * Dave Myron

  * Max Schwenk

## 3.0.2 - 2018-12-23

### Improvements

  * Changed to use strscan in parser.
    [GitHub#52][Patch by 284km]

  * Improves CSV write performance.
    3.0.2 will be about 2 times faster than 3.0.1.

  * Improves CSV parse performance for complex case.
    3.0.2 will be about 2 times faster than 3.0.1.

### Fixes

  * Fixed a parse error bug for new line only input with `headers` option.
    [GitHub#53][Reported by Chris Beer]

  * Fixed some typos in document.
    [GitHub#54][Patch by Victor Shepelev]

### Thanks

  * 284km

  * Chris Beer

  * Victor Shepelev

## 3.0.1 - 2018-12-07

### Improvements

  * Added a test.
    [GitHub#38][Patch by 284km]

  * `CSV::Row#dup`: Changed to duplicate internal data.
    [GitHub#39][Reported by André Guimarães Sakata]

  * Documented `:nil_value` and `:empty_value` options.
    [GitHub#41][Patch by OwlWorks]

  * Added support for separator detection for non-seekable inputs.
    [GitHub#45][Patch by Ilmari Karonen]

  * Removed needless code.
    [GitHub#48][Patch by Espartaco Palma]

  * Added support for parsing header only CSV with `headers: true`.
    [GitHub#47][Patch by Kazuma Shibasaka]

  * Added support for coverage report in CI.
    [GitHub#48][Patch by Espartaco Palma]

  * Improved auto CR row separator detection.
    [GitHub#51][Reported by Yuki Kurihara]

### Fixes

  * Fixed a typo in document.
    [GitHub#40][Patch by Marcus Stollsteimer]

### Thanks

  * 284km

  * André Guimarães Sakata

  * Marcus Stollsteimer

  * OwlWorks

  * Ilmari Karonen

  * Espartaco Palma

  * Kazuma Shibasaka

  * Yuki Kurihara

## 3.0.0 - 2018-06-06

### Fixes

  * Fixed a bug that header isn't returned for empty row.
    [GitHub#37][Patch by Grace Lee]

### Thanks

  * Grace Lee

## 1.0.2 - 2018-05-03

### Improvements

  * Split file for CSV::VERSION

  * Code cleanup: Split csv.rb into a more manageable structure
    [GitHub#19][Patch by Espartaco Palma]
    [GitHub#20][Patch by Steven Daniels]

  * Use CSV::MalformedCSVError for invalid encoding line
    [GitHub#26][Reported by deepj]

  * Support implicit Row <-> Array conversion
    [Bug #10013][ruby-core:63582][Reported by Dawid Janczak]

  * Update class docs
    [GitHub#32][Patch by zverok]

  * Add `Row#each_pair`
    [GitHub#33][Patch by zverok]

  * Improve CSV performance
    [GitHub#30][Patch by Watson]

  * Add :nil_value and :empty_value option

### Fixes

  * Fix a bug that "bom|utf-8" doesn't work
    [GitHub#23][Reported by Pavel Lobashov]

  * `CSV::Row#to_h`, `#to_hash`: uses the same value as `Row#[]`
    [Bug #14482][Reported by tomoya ishida]

  * Make row separator detection more robust
    [GitHub#25][Reported by deepj]

  * Fix a bug that too much separator when col_sep is `" "`
    [Bug #8784][ruby-core:63582][Reported by Sylvain Laperche]

### Thanks

  * Espartaco Palma

  * Steven Daniels

  * deepj

  * Dawid Janczak

  * zverok

  * Watson

  * Pavel Lobashov

  * tomoya ishida

  * Sylvain Laperche

  * Ryunosuke Sato

## 1.0.1 - 2018-02-09

### Improvements

  * `CSV::Table#delete`: Added bulk delete support. You can delete
    multiple rows and columns at once.
    [GitHub#4][Patch by Vladislav]

  * Updated Gem description.
    [GitHub#11][Patch by Marcus Stollsteimer]

  * Code cleanup.
    [GitHub#12][Patch by Marcus Stollsteimer]
    [GitHub#14][Patch by Steven Daniels]
    [GitHub#18][Patch by takkanm]

  * `CSV::Table#dig`: Added.
    [GitHub#15][Patch by Tomohiro Ogoke]

  * `CSV::Row#dig`: Added.
    [GitHub#15][Patch by Tomohiro Ogoke]

  * Added ISO 8601 support to date time converter.
    [GitHub#16]

### Fixes

  * Fixed wrong `CSV::VERSION`.
    [GitHub#10][Reported by Marcus Stollsteimer]

  * `CSV.generate`: Fixed a regression bug that `String` argument is
    ignored.
    [GitHub#13][Patch by pavel]

### Thanks

  * Vladislav

  * Marcus Stollsteimer

  * Steven Daniels

  * takkanm

  * Tomohiro Ogoke

  * pavel
