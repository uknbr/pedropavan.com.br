#!/usr/bin/env bash
BASEDIR=$(dirname "${BASH_SOURCE}")
source ${BASEDIR}/lib.sh

_vars=$(mktemp)
parse_yaml ${resume_yaml} > ${_vars}
source ${_vars}

template_init
template_about
template_education ${_vars}
template_course ${_vars}
template_experience ${_vars}
template_contact ${_vars}
template_skill ${_vars}
template_language ${_vars}
template_hobbie ${_vars}

for _filename in $(find ${BASEDIR}/ -type f -iname '*.tmpl' | sort) ; do
   _target=$(echo "${BASEDIR}/${_filename%.*}")
   echo "Generating ${_filename}"
   /usr/bin/envsubst < ${_filename} > ${_target}
   cat ${_target} >> ${resume_html}
done

items=$(cat ${_vars} | wc -l)
echo "{
   \"status\": {
      \"items\": \"${items}\",
      \"update\": \"$(date)\"
   }
}" | tee ${BASEDIR}/template/status.json

rm -f ${_vars}
exit 0