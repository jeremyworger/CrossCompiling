{% macro protocol_heirarchy(package, type) -%}
{%- if type.protocols %}
< {{",".join(type.protocols) }} >
{%- else %}
< NSObject >
{%- endif %}
{%- endmacro %}

{% macro class_heirarchy(package, type) -%}
{{ type.base_class -}}
{%- if type.protocols %}
< {{",".join(type.protocols) }} >
{%- endif %}
{%- endmacro %}

{% macro interfaces_list(type) %}
{% for interface in type.interfaces %}
{% if loop.first %}<{% endif %}
 {{ interface.name.objc_name -}}
{% if not loop.last %},{% endif %}
{% if loop.last %} >{% endif %}
{% endfor %}
{% endmacro %}

{% macro method_signature(method) -%}
{% if method.is_overridden %}
- ({{ method.return_type.objc_type }}){{ method.name -}}
{% for parameter in method.parameters %}
{% if loop.first %}
With{{ parameter.type.objc_arg_name }}:({{ parameter.type.objc_type }}){{ parameter.variable.name }}
{%- else %}
 with{{ parameter.type.objc_arg_name }}:({{ parameter.type.objc_type }}){{ parameter.variable.name }}
{%- endif %}
{% endfor %}
{% else %}
- ({{ method.return_type.objc_type }}){{ method.name -}}
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

{% macro method_call(method) -%}
    _common->{{ method.name }}({{ method_call_args(method=method) }})
{%- endmacro %}

{% macro methods_impl(type) %}
#pragma mark - {{ type.name.cpp_type }}

{% for method in type.body %}
{{ method_signature(method=method) }}
{
{% if "void" != method.return_type.objc_type %}
{% if method.return_type.native %}
    return {{ method_call(method=method) }};
{% else %}
    return Glympse::ClassBinder::bind({{ method_call(method=method) }});
{% endif %}
{% else %}
    {{ method_call(method=method) }};
{% endif %}
}

{% endfor %}
{% endmacro %}