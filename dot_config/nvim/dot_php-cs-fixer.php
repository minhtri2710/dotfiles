<?php

use PhpCsFixer\Config;
use PhpCsFixer\Finder;

$finder = (new Finder())->in(__DIR__);

return (new Config())
	->setRules([
		'@PhpCsFixer' => true,
		'blank_line_before_statement' => [
			'statements' => [
				'break', 'continue', 'declare', 'exit', 'goto', 'include', 'include_once', 'phpdoc', 'require', 'require_once', 'return', 'switch', 'throw', 'try', 'yield', 'yield_from',
			],
		],
		'no_extra_blank_lines' => [
			'tokens' => [
				'attribute', 'break', 'case', 'continue', 'curly_brace_block', 'default', 'extra', 'parenthesis_brace_block', 'return', 'square_brace_block', 'switch', 'throw',
			],
		],
		'class_attributes_separation' => [
			'elements' => [
				'const' => 'none',
				'method' => 'one',
				'property' => 'none',
				'trait_import' => 'none',
			],
		],
		'single_line_empty_body' => false,
		'concat_space' => ['spacing' => 'one'],
		'multiline_whitespace_before_semicolons' => [
			'strategy' => 'no_multi_line',
		],
		'method_argument_space' => [
			'on_multiline' => 'ensure_fully_multiline',
			'keep_multiple_spaces_after_comma' => false,
			'attribute_placement' => 'same_line',
		],
		'curly_braces_position' => [
			'classes_opening_brace' => 'same_line',
			'functions_opening_brace' => 'same_line',
			'allow_single_line_empty_anonymous_classes' => true,
		],
		'cast_spaces' => [
			'space' => 'none',
		],
		'fully_qualified_strict_types' => [
			'import_symbols' => false,
		],
	])
	->setIndent("\t")
	->setFinder($finder);
