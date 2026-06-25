#!/usr/bin/env node
// Runs `tsc --noEmit`, but treats "no input files yet" (TS18003) as success so
// the repo type-checks cleanly before any TS/JS scripts exist. Once real files
// land under the tsconfig `include` globs, this behaves like a plain `tsc`.
import { spawnSync } from 'node:child_process';

const tsc = process.platform === 'win32' ? 'tsc.cmd' : 'tsc';
const result = spawnSync(tsc, ['--noEmit', '--pretty', 'false'], {
  encoding: 'utf8',
  shell: process.platform === 'win32',
});

const output = `${result.stdout ?? ''}${result.stderr ?? ''}`;
const onlyNoInputs = result.status !== 0 && /error TS18003/.test(output);

if (onlyNoInputs) {
  console.log('type-check: no TS/JS files to check yet — skipping.');
  process.exit(0);
}

if (output.trim()) process.stdout.write(output);
process.exit(result.status ?? 0);
