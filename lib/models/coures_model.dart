class CouresModel {
  bool? ok;
  Meta? meta;
  Data? data;

  CouresModel({this.ok, this.meta, this.data});

  CouresModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'] as bool?;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['ok'] = ok;
    if (meta != null) {
      dataMap['meta'] = meta!.toJson();
    }
    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    return dataMap;
  }
}

class Meta {
  String? api;
  String? endpoint;
  String? mode;
  double? latencyMs;
  int? recordCount;
  int? bytes;
  bool? cacheHit;
  String? stopReason;
  String? method;
  int? page;
  int? totalCount;
  int? totalPages;
  bool? hasMore;
  int? nextPage;

  Meta({
    this.api,
    this.endpoint,
    this.mode,
    this.latencyMs,
    this.recordCount,
    this.bytes,
    this.cacheHit,
    this.stopReason,
    this.method,
    this.page,
    this.totalCount,
    this.totalPages,
    this.hasMore,
    this.nextPage,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    api = json['api']?.toString();
    endpoint = json['endpoint']?.toString();
    mode = json['mode']?.toString();
    latencyMs = (json['latency_ms'] as num?)?.toDouble();
    recordCount = (json['record_count'] as num?)?.toInt();
    bytes = (json['bytes'] as num?)?.toInt();
    cacheHit = json['cache_hit'] as bool?;
    stopReason = json['stop_reason']?.toString();
    method = json['method']?.toString();
    page = (json['page'] as num?)?.toInt();
    totalCount = (json['total_count'] as num?)?.toInt();
    totalPages = (json['total_pages'] as num?)?.toInt();
    hasMore = json['has_more'] as bool?;
    nextPage = (json['next_page'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['api'] = api;
    data['endpoint'] = endpoint;
    data['mode'] = mode;
    data['latency_ms'] = latencyMs;
    data['record_count'] = recordCount;
    data['bytes'] = bytes;
    data['cache_hit'] = cacheHit;
    data['stop_reason'] = stopReason;
    data['method'] = method;
    data['page'] = page;
    data['total_count'] = totalCount;
    data['total_pages'] = totalPages;
    data['has_more'] = hasMore;
    data['next_page'] = nextPage;
    return data;
  }
}

class Data {
  List<Results>? results;

  Data({this.results});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      for (var v in json['results']) {
        if (v is Map<String, dynamic>) {
          results!.add(Results.fromJson(v));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? id;
  String? name;
  String? url;
  String? slug;
  String? type;
  String? difficulty;
  String? duration;
  double? rating;
  int? reviewCount;
  List<String>? partners;
  List<String>? skills;
  bool? isFree;
  bool? isCourseraPlus;
  String? image;
  String? tagline;

  Results({
    this.id,
    this.name,
    this.url,
    this.slug,
    this.type,
    this.difficulty,
    this.duration,
    this.rating,
    this.reviewCount,
    this.partners,
    this.skills,
    this.isFree,
    this.isCourseraPlus,
    this.image,
    this.tagline,
  });

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    url = json['url']?.toString();
    slug = json['slug']?.toString();
    type = json['type']?.toString();
    difficulty = json['difficulty']?.toString();
    duration = json['duration']?.toString();
    rating = (json['rating'] as num?)?.toDouble();
    reviewCount = (json['review_count'] as num?)?.toInt();
    partners = json['partners'] != null
        ? List<String>.from((json['partners'] as List).map((e) => e.toString()))
        : [];
    skills = json['skills'] != null
        ? List<String>.from((json['skills'] as List).map((e) => e.toString()))
        : [];
    isFree = json['is_free'] as bool?;
    isCourseraPlus = json['is_coursera_plus'] as bool?;
    image = json['image']?.toString();
    tagline = json['tagline']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['slug'] = slug;
    data['type'] = type;
    data['difficulty'] = difficulty;
    data['duration'] = duration;
    data['rating'] = rating;
    data['review_count'] = reviewCount;
    data['partners'] = partners;
    data['skills'] = skills;
    data['is_free'] = isFree;
    data['is_coursera_plus'] = isCourseraPlus;
    data['image'] = image;
    data['tagline'] = tagline;
    return data;
  }
}
