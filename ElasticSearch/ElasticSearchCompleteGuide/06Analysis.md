# Elastic Search Complete guide - Analysis

## Text Analysis

* Applicable to text field/values
* Text values are analyzied before being indexed
* The result is stored in data structures that are efficient for searching * The `_source` object is not used when searching for documents as it is not efficient to process the whole text.
** The analyzer has ***character filter***, ***tokenizer*** & **token filters***.

### Character filter

Adds, removes or changes characters. Analyzers contains 0 or more filters.
Filters are applied in the order of in which they are specified.
Eg, for html content a `html_strip` filter can be used to strip html tags.

### Tokenizers

An analyzer contains one token filter. Tokenizes a string i.e, splits it into tokens.
Characters may be stripped as part of tokenization
e.g input: `"I REALLY like beer!"`, output: `["I", "REALLY", "like", "beer"]`

### Token filters

Receives the output of a tokenizer as input (the tokens). It can add, remove or modify tokens. An analyzer has 0 or more token filters
Token filters are applied in the order thery are specified
e.g of lowercase filter, input: `["I", "REALLY", "like", "beer"]`, output: `["i", "really", "like", "beer"]`.

These behaviours are the standard / default behaviour of an analyzers.

### how are keyword fields analyzed

* Analyzed with the keyword analyzer
* It is a no-op analyzer (Outputs the unmodified string as a single token which is placed in the inverted index)
* keyword fields are used for exact matching, aggregations & sorting
* e.g: email addresses, product status, tags

## Inverted indices

Sentences / text are tokenized. These tokens are then associated to the document by the document id. Searches are made easy by lookignup the tokens are retrieving the related documents. Inverted index exist in scope of fields.

### Type coercion

It is enabled by default. Can be set at index or field level. Field level will overwrite index level setting

```c#
PUT my-index-000001
{
  "settings": { "index.mapping.coerce": false },
  "mappings": {
    "properties": {
      "number_one": { "type": "integer", "coerce": true },
      "number_two": { "type": "integer" }
    }
  }
}

PUT my-index-000001/_doc/1
{ "number_one": "10" }

PUT my-index-000001/_doc/2
{ "number_two": "10" }
```

```c#
// Creates an index and indexes a documment where ES coerces the type to float
PUT /coercion_text/_doc/1
{ "price": 7.4 }

// Again, index is valid as the type can be converted to float
PUT /coercion_text/_doc/2
{ "price": "7.4" }

// throws error since the value is not float
PUT /coercion_text/_doc/3
{"price": "7.4m" }

// result shows the data type of the field price as float
GET /coercion_text/_mapping
// cleanup
DELETE /coercion_text
```

### Arrays

There are no array type the analyzer treats them as a single text.
There cannot be different data type used in the array, as in where it cannot be coerced.

## Stemming & stop words

### Stemming

The standard analyzer tokenized words in a string as it is (also lowercases and removed puncuations) in the inverted index. Stemming allows changing words into their root form before tokenizing.

#### Stemming Example

"I loved drinking bottles of wine on last year's vacation"

* loved = past tense
* drinking = gerund
* bottles = plural
* year's = possession

"I love drink bottl of wine on last year vacat"

### stop words

Words that a filtered out during text analysis such as "a", "at", "the", "of", "on", etc
They provide little to no value to relevance scoring.
Fairly common to remove such words but less common now since the relevance algorithm has improved significantly.
They are not removed by default and recommended not to do so as well.

e.g "I love drinking bottles wine last year's vacation"

### Built-in and custom components

We can have other built-in components for analyziers or use custom ones.

```c#
POST /_analyze
{
  "text": "2 guys walks into  a bar, but the third one... DUCKS! :-)",
  "analyzer": "standard"
}

POST /_analyze
{
  "text": "2 guys walks into  a bar, but the third one... DUCKS! :-)",
  "char_filter": [],
  "tokenizer": "standard",
  "filter": ["lowercase"]
}
```

## Built-in Analyzers

### Standard

Splits text at word boundaries and removed punctuation (done by standard tokenizer).
Lowercases letters with the token filter.
Contains the stop token filter (disabled by default)

### Simple

Splits into tokens when encountering anything else than letters
Lowercase letters by using the tokenizer (instead of a token filter, performance hack)

### whitespace

Splits text into tokens by whitespace
Does not lowercase letters

### keyword

No-op analyzer that leaves the input text intact

### pattern

Uses Regex to match token seperators
The default pattern matches all non word characters(\W+)
lowercases letters by default

### Others

* language analyzers
* Fingerprint analyzers

### Example: Configure built-in analyzer

```c#
PUT /products
{
    "settings": {
        "analysis": {
            "analyzer": {
                "remove_english_stop_words": {
                    "type": "standard",
                    "stopwords": "_english_"
                }
            }
        }
    }
}

PUT /products/_mapping
{
    "properties": {
        "description": {
            "type": "text",
            "analyzer": "remove_english_stop_words"
        }
    }
}
```

### Custom Analyzers

```c#
POST /_analyze
{
    "analyzer": "standard,
    "text": "I&apos;m in a <em>good</em> mood&nbsp;-&nbsp;and I <strong>love</strong> açaí!"
}
POST /_analyze
{
    "char_filter": ["html_string"],
    "text": "I&apos;m in a <em>good</em> mood&nbsp;-&nbsp;and I <strong>love</strong> açaí!"
}

PUT /analyzer_test
{
    "settings": {
        "analysys": {
            "analyzer": {
                "custom_analyzer": {
                    "type": "custom",
                    "char_filter": ["html_string"],
                    "tokenizer": "standard",
                    "filter": ["lowercase", "stop", "asciifolding"]

                }
            }
        }
    }
}

POST /analyzer_test/_analyze
{
    "analyzer": "custom_analyzer",
    "text": "I&apos;m in a <em>good</em> mood&nbsp;-&nbsp;and I <strong>love</strong> açaí!"
}

PUT /analyzer_test
{
    "settings": {
        "analysys": {
            "filter": {
                "danish_stop": {
                    "type": "stop",
                    "stopwords": "_danish_"
                }
            },
            "analyzer": {
                "custom_analyzer": {
                    "type": "custom",
                    "char_filter": ["html_string"],
                    "tokenizer": "standard",
                    "filter": ["lowercase", "danish_stop", "asciifolding"]
                }
            }
        }
    }
}
```

### Adding analyzers to existing indices

There 2 kind of settings for index settings, static and dynamic.
Dynamic settings can be changed on an open index.
Static settings needs the index to be closed first.

```c#
// below request will return an error
// Can't update non dynamic settings and open index.
PUT /analyzer_test/_settings
{
    "analysis": {
        "analyzer": {
            "my_second_analyzer": {
                "type": "custom",
                "tokenizer": "standard",
                "char_filter": ["html_string"],
                "filter": ["lowercase", "stop", "asciifolding"]
            }

        }

    }
}

// close the index
POST /analyzer_test/_close

// run the previous query then
POST /analyzer_test/_open

GET /analyzer_test/_settings
```

### Updating analyzers

```c#
PUT /analyzer_test/_mapping
{
    "properties": {
        "description": {
            "type": "text",
            "analyzer": "my_custom_analyzer"
        }
    }
}

POST /analyzer_test/_doc
{
    "description": "Is that Peter's cute-looking dog?"
}

// no documents are matched
// we used customer analyzer to index the doc where we have the stop token filter
// which means the word 'that' is not available in our inverted index
// the query ovewrites the analyzer.
GET /analyzer_test/_search
{
    "query": {
        "match": {
            "description": {
                "query": "that",
                "analyzer": "keyword"
            }
        }
    }
}

// update the analyzer
POST /analyzer_test/_close

PUT /analyzer_test/_settings
{
    "analysis": {
        "analyzer": {
            "my_second_analyzer": {
                "type": "custom",
                "tokenizer": "standard",
                "char_filter": ["html_string"],
                "filter": ["lowercase", "asciifolding"]
            }

        }

    }
}

POST /analyzer_test/_open

GET /analyzer_test/_settings

// index the document again and do a search again, recently index doc is found.
// resolved issues where initial doc should be updated to match the new analyzer
POST /analyzer_test/_update_by_query?conflicts=proceed
```
