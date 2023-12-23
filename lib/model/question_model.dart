class QuestionModel {
  String? title;
  String? name;
  String? slug;
  String? description;
  MainSchema? schema;

  QuestionModel(
      {this.title, this.name, this.slug, this.description, this.schema});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    schema =
        json['schema'] != null ? MainSchema.fromJson(json['schema']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    if (schema != null) {
      data['schema'] = schema!.toJson();
    }
    return data;
  }
}

class MainSchema {
  List<Fields>? fields;

  MainSchema({this.fields});

  MainSchema.fromJson(Map<String, dynamic> json) {
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fields {
  String? type;
  int? version;
  Schema? schema;

  Fields({this.type, this.version, this.schema});

  Fields.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    version = json['version'];
    schema = json['schema'] != null ? Schema.fromJson(json['schema']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['version'] = version;
    if (schema != null) {
      data['schema'] = schema!.toJson();
    }
    return data;
  }
}

class Schema {
  String? name;
  String? label;
  String? answer;
  dynamic hidden;
  dynamic readonly;
  List<Options>? options;
  List<Fields>? fields;

  Schema(
      {this.name,
      this.label,
      this.hidden,
      this.readonly,
      this.answer,
      this.options,
      this.fields});

  Schema.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    hidden = json['hidden'];
    readonly = json['readonly'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['label'] = label;
    data['hidden'] = hidden;
    data['readonly'] = readonly;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? key;
  String? value;

  Options({this.key, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
