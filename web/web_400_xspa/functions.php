<?php

use Elasticsearch\ClientBuilder;

require 'vendor/autoload.php';

function Autocomplete($q) {
    try {
        $client = ClientBuilder::create()->setHosts(['http://localhost:48627'])->build();
        $response = $client->search([
            'index' => 'jaqioalgqe',
            'type' => 'aiwoknqefi',
            'body' => [
                'query' => [
                    'match' => [
                        'full_address' => $q
                    ]
                ]
            ]
        ]);
        $data = [];
        if (isset($response['hits']['hits'])) {
            foreach ($response['hits']['hits'] as $row) {
                $data[$row['_id']] = $row['_source']['full_address'];
            }
        }
        return $data;
    } catch (\Exception $e) {
        return [];
    }
}

function Get($default_url)
{
    try {
        if ($default_url[0] === '.') {
            $preUrl = "http://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}";
            $default_url = substr($preUrl, 0, stripos($preUrl, 'redirecter.php')) . substr($default_url, 2);
        }
        $url = parse_url($default_url);
        if (!isset($url['host']) || $url['host'] == '') {
            return false;
        }
        if (!isset($url['scheme']) || $url['scheme'] != 'http') {
            return false;
        }

        return file_get_contents($default_url);
    } catch (\Exception $e) {
        return false;
    }
}

function GetRandomPronounceableWord($length = 6)
{
    // consonant sounds
    $cons = array(
        // single consonants. Beware of Q, it's often awkward in words
        'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm',
        'n', 'p', 'r', 's', 't', 'v', 'w', 'x', 'z',
        // possible combinations excluding those which cannot start a word
        'pt', 'gl', 'gr', 'ch', 'ph', 'ps', 'sh', 'st', 'th', 'wh',
    );

    // consonant combinations that cannot start a word
    $cons_cant_start = array(
        'ck', 'cm',
        'dr', 'ds',
        'ft',
        'gh', 'gn',
        'kr', 'ks',
        'ls', 'lt', 'lr',
        'mp', 'mt', 'ms',
        'ng', 'ns',
        'rd', 'rg', 'rs', 'rt',
        'ss',
        'ts', 'tch',
    );

    // wovels
    $vows = array(
        // single vowels
        'a', 'e', 'i', 'o', 'u', 'y',
        // vowel combinations your language allows
        'ee', 'oa', 'oo',
    );

    // start by vowel or consonant ?
    $current = (mt_rand(0, 1) == '0' ? 'cons' : 'vows');

    $word = '';

    while (strlen($word) < $length) {

        // After first letter, use all consonant combos
        if (strlen($word) == 2) {
            $cons = array_merge($cons, $cons_cant_start);
        }

        // random sign from either $cons or $vows
        $rnd = ${$current}[mt_rand(0, count(${$current}) - 1)];

        // check if random sign fits in word length
        if (strlen($word . $rnd) <= $length) {
            $word .= $rnd;
            // alternate sounds
            $current = ($current == 'cons' ? 'vows' : 'cons');
        }
    }

    return $word;
}