<?php

const FLAG = '#START8ZU_';
const rootDir = './documents';
const DEPT = 5;
const COUNT_DIR = 5;
const COUNT_FILES = 10;

$flagIsSet = 0;
$flagLength = strlen(FLAG);

@mkdir(rootDir);

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

function generateDir($path, $dept) {
    global $flagIsSet, $flagLength;

    if ($dept <= 0) {
        for ($i = 0; $i < COUNT_FILES; $i++) {
            $fileName = GetRandomPronounceableWord(rand(5, 12));
            if (!$flagIsSet) {
                $flagIsSet = 1;
                $content = FLAG;
            } else {
                $content = GetRandomPronounceableWord($flagLength);
            }
            file_put_contents($path . '/' . $fileName, $content);
        }
    } else {
        for ($i = 0; $i < COUNT_DIR; $i++) {
            $dirName = GetRandomPronounceableWord(rand(5, 12));
            mkdir($path . '/' . $dirName);
            generateDir($path . '/' . $dirName, $dept - 1);
        }
    }
}

generateDir(rootDir, DEPT);
