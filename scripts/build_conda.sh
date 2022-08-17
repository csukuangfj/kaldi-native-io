#!/usr/bin/env bash
#
# Copyright      2022  Xiaomi Corp.       (author: Fangjun Kuang)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The following environment variables are supposed to be set by users
#
# - KALDI_NATIVE_IO_CONDA_TOKEN
#     If not set, auto upload to anaconda.org is disabled.
#
#     Its value is from https://anaconda.org/k2-fsa/settings/access
#      (You need to login as user k2-fsa to see its value)
#
set -e
export CONDA_BUILD=1

cur_dir=$(cd $(dirname $BASH_SOURCE) && pwd)
kaldi_native_io_dir=$(cd $cur_dir/.. && pwd)

cd $kaldi_native_io_dir

export KALDI_NATIVE_IO_ROOT_DIR=$kaldi_native_io_dir
echo "KALDI_NATIVE_IO_ROOT_DIR: $KALDI_NATIVE_IO_ROOT_DIR"

KALDI_NATIVE_IO_PYTHON_VERSION=$(python -c "import sys; print('.'.join(sys.version.split('.')[:2]))")
echo "KALDI_NATIVE_IO_PYTHON_VERSION $KALDI_NATIVE_IO_PYTHON_VERSION"
# Example value: 3.8
export KALDI_NATIVE_IO_PYTHON_VERSION

if [ -z $KALDI_NATIVE_IO_CONDA_TOKEN ]; then
  echo "Auto upload to anaconda.org is disabled since KALDI_NATIVE_IO_CONDA_TOKEN is not set"
  conda build --no-test --no-anaconda-upload ./scripts/conda/kaldi_native_io
else
  conda build --no-test --token $KALDI_NATIVE_IO_CONDA_TOKEN ./scripts/conda/kaldi_native_io
fi
