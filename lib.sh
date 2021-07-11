#!/usr/bin/env bash
BASEDIR=$(dirname "${BASH_SOURCE}")

export resume_html="${BASEDIR}/template/resume.html"
export resume_yaml="${BASEDIR}/pugo.yml"
export resume_tmpl="${BASEDIR}/out"

function template_init() {
	[ -f ${resume_html} ] && rm -f ${resume_html}
	mkdir -p ${resume_tmpl}/
}

function template_about() {
	local _template="${BASEDIR}/${resume_tmpl}/1_resume_about.html.tmpl"

	cat <<EOF > ${_template}
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>\${about_name}</title>
    <link href="bootstrap.min.css" rel="stylesheet">
    <link href="font-awesome.css" rel="stylesheet">
    <link href="main.css" rel="stylesheet">
    <!--[if lt IE 9]>
      <script src="js/html5shiv.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-xs-12">
          <div id="photo-header" class="text-center">
            <!-- PHOTO (AVATAR) -->
            <div id="photo">
              <img src="\${about_photo}" alt="My photo">
            </div>
            <div id="text-header">
              <h1>Hello,<br> my name is <span>\${about_name}</span><sup>\${about_age}yo</sup> and this is my page</h1>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12 col-sm-7">
          <!-- ABOUT ME -->
          <div class="box">
            <h2>About Me</h2>
            <p>\${about_description}</p>
          </div>
EOF
}

function template_education() {
	local _file=$1
	local _template="${BASEDIR}/${resume_tmpl}/2_resume_education.html.tmpl"
	local _max=$(grep 'education_' ${_file} | grep -c '_title')
	
	# Begin
	cat <<EOF > ${_template}
          <!-- EDUCATION -->
          <div class="box">
            <h2>Education</h2>
            <ul id="education" class="clearfix">
EOF

	# Data
	for i in $(seq ${_max})
	do
		cat <<EOF >> ${_template}
              <li>
                <div class="year pull-left">\${education_${i}_year}</div>
                <div class="description pull-right">
                  <h3>\${education_${i}_title}</h3>
                  <p>\${education_${i}_description}</p>
                </div>
              </li>
EOF
	done

	# End
	cat <<EOF >> ${_template}
            </ul>
          </div>
EOF
}

function template_experience() {
	local _file=$1
	local _template="${BASEDIR}/${resume_tmpl}/3_resume_experience.html.tmpl"
	local _max=$(grep 'experience_' ${_file} | grep -c '_where')

	# Begin
	cat <<EOF > ${_template}
          <!-- EXPERIENCES -->
          <div class="box">
            <h2>Experiences</h2>
EOF

	# Data
	for i in $(seq ${_max})
	do
		cat <<EOF >> ${_template}
            <div class="job clearfix">
              <div class="col-xs-3">
                <div class="where">\${experience_${i}_where}</div>
                <div class="year">\${experience_${i}_year}</div>
              </div>
              <div class="col-xs-9">
                <div class="profession">\${experience_${i}_profession}</div>
                <div class="description">\${experience_${i}_description}</div>
              </div>
            </div>
EOF
	done

	# End
	cat <<EOF >> ${_template}
          </div>
        </div>
        <div class="col-xs-12 col-sm-5">
EOF
}

function template_contact() {
	local _file=$1
	local _template="${BASEDIR}/${resume_tmpl}/4_resume_contact.html.tmpl"
	local _max=$(grep 'contact_' ${_file} | grep -c '_title')

	# Begin
	cat <<EOF > ${_template}
          <!-- CONTACT -->
          <div class="box clearfix">
            <h2>Contact</h2>
EOF

	# Data
	source <(grep 'contact_' ${_file})
	for i in $(seq ${_max})
	do
		eval t='$contact_'"${i}"_title
		if [[ "${t}" == "mailto" ]] ; then
			cat <<EOF >> ${_template}
            <div class="contact-item">
              <div class="icon pull-left text-center"><span class="fa \${contact_${i}_icon} fa-fw"></span></div>
              <div class="title only pull-right"><a href="\${contact_${i}_title}:\${contact_${i}_value}">\${contact_${i}_value}</a></div>
            </div>
EOF
		else
			cat <<EOF >> ${_template}
            <div class="contact-item">
              <div class="icon pull-left text-center"><span class="fa \${contact_${i}_icon} fa-fw"></span></div>
              <div class="title pull-right">\${contact_${i}_title}</div>
              <div class="description pull-right"><a href="\${contact_${i}_value}" target="_blank">\${contact_${i}_value}</a></div>
            </div>			
EOF
		fi
	done

	# End
	cat <<EOF >> ${_template}
          </div>
EOF
}

function template_skill() {
	local _file=$1
	local _template="${BASEDIR}/${resume_tmpl}/5_resume_skill.html.tmpl"
	local _max=$(grep 'skill_' ${_file} | grep -c '_title')

	# Begin
	cat <<EOF > ${_template}
          <!-- SKILLS -->
          <div class="box">
            <h2>Skills</h2>
            <div class="skills">
EOF

	# Data
	for i in $(seq ${_max})
	do
		cat <<EOF >> ${_template}
              <div class="item-skills" data-percent="\${skill_${i}_percent}">\${skill_${i}_title}</div>
EOF
	done

	# End
	cat <<EOF >> ${_template}
              <div class="skills-legend clearfix">
                <div class="legend-left legend">Beginner</div>
                <div class="legend-left legend"><span>Proficient</span></div>
                <div class="legend-right legend"><span>Expert</span></div>
                <div class="legend-right legend">Master</div>
              </div>
            </div>
          </div>
EOF
}

function template_language() {
	local _file=$1
	local _template="${BASEDIR}/${resume_tmpl}/6_resume_language.html.tmpl"
	local _max=$(grep 'language_' ${_file} | grep -c '_name')

	# Begin
	cat <<EOF > ${_template}
          <!-- LANGUAGES -->
          <div class="box">
            <h2>Languages</h2>
            <div id="language-skills">
EOF

	# Data
	for i in $(seq ${_max})
	do
		cat <<EOF >> ${_template}
              <div class="skill">\${language_${i}_name} <div class="icons pull-right"><div style="width: \${language_${i}_percent}%;" class="icons-red"></div></div></div>
EOF
	done

	# End
	cat <<EOF >> ${_template}
            </div>
          </div>
EOF
}

function template_hobbie() {
	local _file=$1
	local _template="${BASEDIR}/${resume_tmpl}/7_resume_hobbie.html.tmpl"
	local _max=$(grep -c 'hobbie_' ${_file})

	# Begin
	cat <<EOF > ${_template}
          <!-- HOBBIES -->
          <div class="box">
            <h2>Hobbies</h2>
EOF

	# Data
	for i in $(seq ${_max})
	do
		cat <<EOF >> ${_template}
            <div class="hobby">\${hobbie_${i}}</div>
EOF
	done

	# End
	cat <<EOF >> ${_template}
          </div>
        </div>
      </div>
    </div>
    <!-- JQUERY -->
    <script src="jquery.min.js"></script>
    <!-- BOOTSTRAP -->
    <script src="bootstrap.min.js"></script>
    <!-- SCRIPTS -->
    <script src="scripts.js"></script>
  </body>
</html>
EOF
}

#https://github.com/mrbaseman/parse_yaml
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|,$s\]$s\$|]|" \
        -e ":1;s|^\($s\)\($w\)$s:$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1\2: [\3]\n\1  - \4|;t1" \
        -e "s|^\($s\)\($w\)$s:$s\[$s\(.*\)$s\]|\1\2:\n\1  - \3|;p" $1 | \
   sed -ne "s|,$s}$s\$|}|" \
        -e ":1;s|^\($s\)-$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1- {\2}\n\1  \3: \4|;t1" \
        -e    "s|^\($s\)-$s{$s\(.*\)$s}|\1-\n\1  \2|;p" | \
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)-$s[\"']\(.*\)[\"']$s\$|\1$fs$fs\2|p" \
        -e "s|^\($s\)-$s\(.*\)$s\$|\1$fs$fs\2|p" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" | \
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]; idx[i]=0}}
      if(length($2)== 0){  vname[indent]= ++idx[indent] };
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) { vn=(vn)(vname[i])("_")}
         printf("export %s%s%s=\"%s\"\n", "'$prefix'",vn, vname[indent], $3);
      }
   }'
}