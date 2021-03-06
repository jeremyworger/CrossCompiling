{% macro method_signature(method) -%}
{% if method.is_overridden %}
+ ({{ method.return_type.objc_type }}){{ method.name -}}
{% for parameter in method.parameters %}
{% if loop.first %}
With{{ parameter.type.objc_arg_name }}:({{ parameter.type.objc_type }}){{ parameter.variable.name }}
{%- else %}
 with{{ parameter.type.objc_arg_name }}:({{ parameter.type.objc_type }}){{ parameter.variable.name }}
{%- endif %}
{% endfor %}
{% else %}
+ ({{ method.return_type.objc_type }}){{ method.name -}}
{% for parameter in method.parameters %}
{% if loop.first %}
:({{ parameter.type.objc_type }}){{ parameter.variable.name }}
{%- else %}
 {{ parameter.variable.name }}:({{ parameter.type.objc_type }}){{ parameter.variable.name }}
{%- endif %}
{% endfor %}
{% endif %}
{%- endmacro %}

{% macro method_call_args(method) -%}
{% for parameter in method.parameters %}
{% if method.is_overridden %}
({{ parameter.type.cpp_type }})
{%- endif %}
{% if parameter.type.native %}
{{ parameter.variable.name }}
{%- else %}
Glympse::ClassBinder::unwrap({{ parameter.variable.name }})
{%- endif %}
{% if not loop.last %}, {% endif %}
{% endfor %}
{%- endmacro %}
