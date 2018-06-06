#!/usr/bin/env bash

set -x
set -e
set -u
set -o pipefail

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHALLENGE_ID=$1
RUBY_TEST_REPORT_CSV_FILE="${SCRIPT_CURRENT_DIR}/coverage/results.csv"
RUBY_CODE_COVERAGE_INFO="${SCRIPT_CURRENT_DIR}/coverage.tdl"

( cd ${SCRIPT_CURRENT_DIR} && \
    gem install bundler && \
    bundle install && \
    rake test || true 1>&2 )

[ -e ${RUBY_CODE_COVERAGE_INFO} ] && rm ${RUBY_CODE_COVERAGE_INFO}

if [ -f "${RUBY_TEST_REPORT_CSV_FILE}" ]; then
    TOTAL_COVERAGE_PERCENTAGE=$(( 0 ))
    NUMBER_OF_FILES=$(( 0 ))

    COVERAGE_OUTPUT=$(grep ${CHALLENGE_ID} ${RUBY_TEST_REPORT_CSV_FILE} | tr ',' ' ')
    while read coveragePerFile;
    do
        coverageForThisFile=$(echo ${coveragePerFile} | awk '{print $2}')
        TOTAL_COVERAGE_PERCENTAGE=$(( ${TOTAL_COVERAGE_PERCENTAGE} + ${coverageForThisFile} ))
        NUMBER_OF_FILES=$(( ${NUMBER_OF_FILES} + 1 ))
    done <<< ${COVERAGE_OUTPUT}

    AVERAGE_COVERAGE_PERCENTAGE=$(( ${TOTAL_COVERAGE_PERCENTAGE} / ${NUMBER_OF_FILES} ))

    echo $((AVERAGE_COVERAGE_PERCENTAGE)) > ${RUBY_CODE_COVERAGE_INFO}
    cat ${RUBY_CODE_COVERAGE_INFO}
    exit 0
else
    echo "No coverage report was found"
    exit -1
fi
