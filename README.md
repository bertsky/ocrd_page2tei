# ocrd_page2tei

    OCR-D wrapper for [page2tei](https://github.com/tboenig/page2tei)

  * [Introduction](#introduction)
  * [Installation](#installation)
  * [Usage](#usage)
     * [OCR-D processor interface ocrd-page2tei](#ocr-d-processor-interface-ocrd-page2tei)
  * [Testing](#testing)


## Introduction

This offers an [OCR-D](https://ocr-d.de) compliant [workspace processor](https://ocr-d.de/en/spec/cli) for
[TEI](https://tei-c.org/) conversion.

It _wraps_ the XSL transformation [page2tei](https://github.com/tboenig/page2tei)
for OCR-D:

 * For XSL processing, it uses [Saxon](http://www.saxonica.com/).

 * For handling METS/PAGE, and providing the OCR-D CLI, it is written as a shell script,
and relies heavily on the [OCR-D core bashlib API](https://github.com/OCR-D/core).

## Installation

Requires Java>=8, [Saxon](http://www.saxonica.com/) and [GNU make](http://www.gnu.org/software/make).

To install system dependencies on Ubuntu, do

    sudo make deps-ubuntu

Which is the equivalent of:

    apt install openjdk-8-jre-headless

To install local dependencies (download Saxon and page2tei), do

    make deps

To install this module, then do:

    make install

## Usage

### [OCR-D processor](https://ocr-d.de/en/spec/cli) interface `ocrd-page2tei`

To be used with [PAGE-XML](https://github.com/PRImA-Research-Lab/PAGE-XML) documents in an [OCR-D](https://ocr-d.de/en/about) annotation workflow.

```
Usage: ocrd-page2tei [OPTIONS]

Convert PAGE-XML to TEI-C

Options:
  -I, --input-file-grp USE        File group(s) used as input
  -O, --output-file-grp USE       File group(s) used as output
  -g, --page-id ID                Physical page ID(s) to process
  --overwrite                     Remove existing output pages/images
                                  (with --page-id, remove only those)
  -p, --parameter JSON-PATH       Parameters, either verbatim JSON string
                                  or JSON file path
  -P, --param-override KEY VAL    Override a single JSON object key-value pair,
                                  taking precedence over --parameter
  -m, --mets URL-PATH             URL or file path of METS to process
  -w, --working-dir PATH          Working directory of local workspace
  -l, --log-level [OFF|ERROR|WARN|INFO|DEBUG|TRACE]
                                  Log level
  -J, --dump-json                 Dump tool description as JSON and exit
  -h, --help                      This help message
  -V, --version                   Show version

```

## Testing

none yet

