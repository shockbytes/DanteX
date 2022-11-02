class GoogleBooksResponse {
  GoogleBooksResponse({
      String? kind,
      num totalItems = 0,
      List<Items> items = const []}){
    _kind = kind;
    _totalItems = totalItems;
    _items = items;
}

  GoogleBooksResponse.fromJson(dynamic json) {
    _kind = json['kind'];
    _totalItems = json['totalItems'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items.add(Items.fromJson(v));
      });
    }
  }
  String? _kind;
  num? _totalItems;
  late List<Items> _items;

  String? get kind => _kind;
  num? get totalItems => _totalItems;
  List<Items> get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['kind'] = _kind;
    map['totalItems'] = _totalItems;
    map['items'] = _items.map((v) => v.toJson()).toList();
    return map;
  }

}

class Items {
  Items({
      String? kind,
      String? id,
      String? etag,
      String? selfLink,
      VolumeInfo? volumeInfo,
      SaleInfo? saleInfo,
      AccessInfo? accessInfo,
      SearchInfo? searchInfo,}){
    _kind = kind;
    _id = id;
    _etag = etag;
    _selfLink = selfLink;
    _volumeInfo = volumeInfo;
    _saleInfo = saleInfo;
    _accessInfo = accessInfo;
    _searchInfo = searchInfo;
}

  Items.fromJson(dynamic json) {
    _kind = json['kind'];
    _id = json['id'];
    _etag = json['etag'];
    _selfLink = json['selfLink'];
    _volumeInfo = json['volumeInfo'] != null ? VolumeInfo.fromJson(json['volumeInfo']) : null;
    _saleInfo = json['saleInfo'] != null ? SaleInfo.fromJson(json['saleInfo']) : null;
    _accessInfo = json['accessInfo'] != null ? AccessInfo.fromJson(json['accessInfo']) : null;
    _searchInfo = json['searchInfo'] != null ? SearchInfo.fromJson(json['searchInfo']) : null;
  }
  String? _kind;
  String? _id;
  String? _etag;
  String? _selfLink;
  VolumeInfo? _volumeInfo;
  SaleInfo? _saleInfo;
  AccessInfo? _accessInfo;
  SearchInfo? _searchInfo;

  String? get kind => _kind;
  String? get id => _id;
  String? get etag => _etag;
  String? get selfLink => _selfLink;
  VolumeInfo? get volumeInfo => _volumeInfo;
  SaleInfo? get saleInfo => _saleInfo;
  AccessInfo? get accessInfo => _accessInfo;
  SearchInfo? get searchInfo => _searchInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['kind'] = _kind;
    map['id'] = _id;
    map['etag'] = _etag;
    map['selfLink'] = _selfLink;
    if (_volumeInfo != null) {
      map['volumeInfo'] = _volumeInfo?.toJson();
    }
    if (_saleInfo != null) {
      map['saleInfo'] = _saleInfo?.toJson();
    }
    if (_accessInfo != null) {
      map['accessInfo'] = _accessInfo?.toJson();
    }
    if (_searchInfo != null) {
      map['searchInfo'] = _searchInfo?.toJson();
    }
    return map;
  }

}

class SearchInfo {
  SearchInfo({
      String? textSnippet,}){
    _textSnippet = textSnippet;
}

  SearchInfo.fromJson(dynamic json) {
    _textSnippet = json['textSnippet'];
  }
  String? _textSnippet;

  String? get textSnippet => _textSnippet;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['textSnippet'] = _textSnippet;
    return map;
  }

}

class AccessInfo {
  AccessInfo({
      String? country,
      String? viewability,
      bool? embeddable,
      bool? publicDomain,
      String? textToSpeechPermission,
      Epub? epub,
      Pdf? pdf,
      String? webReaderLink,
      String? accessViewStatus,
      bool? quoteSharingAllowed,}){
    _country = country;
    _viewability = viewability;
    _embeddable = embeddable;
    _publicDomain = publicDomain;
    _textToSpeechPermission = textToSpeechPermission;
    _epub = epub;
    _pdf = pdf;
    _webReaderLink = webReaderLink;
    _accessViewStatus = accessViewStatus;
    _quoteSharingAllowed = quoteSharingAllowed;
}

  AccessInfo.fromJson(dynamic json) {
    _country = json['country'];
    _viewability = json['viewability'];
    _embeddable = json['embeddable'];
    _publicDomain = json['publicDomain'];
    _textToSpeechPermission = json['textToSpeechPermission'];
    _epub = json['epub'] != null ? Epub.fromJson(json['epub']) : null;
    _pdf = json['pdf'] != null ? Pdf.fromJson(json['pdf']) : null;
    _webReaderLink = json['webReaderLink'];
    _accessViewStatus = json['accessViewStatus'];
    _quoteSharingAllowed = json['quoteSharingAllowed'];
  }
  String? _country;
  String? _viewability;
  bool? _embeddable;
  bool? _publicDomain;
  String? _textToSpeechPermission;
  Epub? _epub;
  Pdf? _pdf;
  String? _webReaderLink;
  String? _accessViewStatus;
  bool? _quoteSharingAllowed;

  String? get country => _country;
  String? get viewability => _viewability;
  bool? get embeddable => _embeddable;
  bool? get publicDomain => _publicDomain;
  String? get textToSpeechPermission => _textToSpeechPermission;
  Epub? get epub => _epub;
  Pdf? get pdf => _pdf;
  String? get webReaderLink => _webReaderLink;
  String? get accessViewStatus => _accessViewStatus;
  bool? get quoteSharingAllowed => _quoteSharingAllowed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = _country;
    map['viewability'] = _viewability;
    map['embeddable'] = _embeddable;
    map['publicDomain'] = _publicDomain;
    map['textToSpeechPermission'] = _textToSpeechPermission;
    if (_epub != null) {
      map['epub'] = _epub?.toJson();
    }
    if (_pdf != null) {
      map['pdf'] = _pdf?.toJson();
    }
    map['webReaderLink'] = _webReaderLink;
    map['accessViewStatus'] = _accessViewStatus;
    map['quoteSharingAllowed'] = _quoteSharingAllowed;
    return map;
  }

}

class Pdf {
  Pdf({
      bool? isAvailable,}){
    _isAvailable = isAvailable;
}

  Pdf.fromJson(dynamic json) {
    _isAvailable = json['isAvailable'];
  }
  bool? _isAvailable;

  bool? get isAvailable => _isAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isAvailable'] = _isAvailable;
    return map;
  }

}

class Epub {
  Epub({
      bool? isAvailable,}){
    _isAvailable = isAvailable;
}

  Epub.fromJson(dynamic json) {
    _isAvailable = json['isAvailable'];
  }
  bool? _isAvailable;

  bool? get isAvailable => _isAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isAvailable'] = _isAvailable;
    return map;
  }

}

class SaleInfo {
  SaleInfo({
      String? country,
      String? saleability,
      bool? isEbook,}){
    _country = country;
    _saleability = saleability;
    _isEbook = isEbook;
}

  SaleInfo.fromJson(dynamic json) {
    _country = json['country'];
    _saleability = json['saleability'];
    _isEbook = json['isEbook'];
  }
  String? _country;
  String? _saleability;
  bool? _isEbook;

  String? get country => _country;
  String? get saleability => _saleability;
  bool? get isEbook => _isEbook;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = _country;
    map['saleability'] = _saleability;
    map['isEbook'] = _isEbook;
    return map;
  }

}

class VolumeInfo {
  VolumeInfo({
      String? title,
      String? subtitle,
      List<String>? authors,
      String? publishedDate,
      List<IndustryIdentifiers>? industryIdentifiers,
      ReadingModes? readingModes,
      num? pageCount,
      String? printType,
      num? averageRating,
      num? ratingsCount,
      String? maturityRating,
      bool? allowAnonLogging,
      String? contentVersion,
      ImageLinks? imageLinks,
      String? language,
      String? previewLink,
      String? infoLink,
      String? canonicalVolumeLink,}){
    _title = title;
    _subtitle = subtitle;
    _authors = authors;
    _publishedDate = publishedDate;
    _industryIdentifiers = industryIdentifiers;
    _readingModes = readingModes;
    _pageCount = pageCount;
    _printType = printType;
    _averageRating = averageRating;
    _ratingsCount = ratingsCount;
    _maturityRating = maturityRating;
    _allowAnonLogging = allowAnonLogging;
    _contentVersion = contentVersion;
    _imageLinks = imageLinks;
    _language = language;
    _previewLink = previewLink;
    _infoLink = infoLink;
    _canonicalVolumeLink = canonicalVolumeLink;
}

  VolumeInfo.fromJson(dynamic json) {
    _title = json['title'];
    _subtitle = json['subtitle'];
    _authors = json['authors'] != null ? json['authors'].cast<String>() : [];
    _publishedDate = json['publishedDate'];
    if (json['industryIdentifiers'] != null) {
      _industryIdentifiers = [];
      json['industryIdentifiers'].forEach((v) {
        _industryIdentifiers?.add(IndustryIdentifiers.fromJson(v));
      });
    }
    _readingModes = json['readingModes'] != null ? ReadingModes.fromJson(json['readingModes']) : null;
    _pageCount = json['pageCount'];
    _printType = json['printType'];
    _averageRating = json['averageRating'];
    _ratingsCount = json['ratingsCount'];
    _maturityRating = json['maturityRating'];
    _allowAnonLogging = json['allowAnonLogging'];
    _contentVersion = json['contentVersion'];
    _imageLinks = json['imageLinks'] != null ? ImageLinks.fromJson(json['imageLinks']) : null;
    _language = json['language'];
    _previewLink = json['previewLink'];
    _infoLink = json['infoLink'];
    _canonicalVolumeLink = json['canonicalVolumeLink'];
  }
  String? _title;
  String? _subtitle;
  List<String>? _authors;
  String? _publishedDate;
  List<IndustryIdentifiers>? _industryIdentifiers;
  ReadingModes? _readingModes;
  num? _pageCount;
  String? _printType;
  num? _averageRating;
  num? _ratingsCount;
  String? _maturityRating;
  bool? _allowAnonLogging;
  String? _contentVersion;
  ImageLinks? _imageLinks;
  String? _language;
  String? _previewLink;
  String? _infoLink;
  String? _canonicalVolumeLink;

  String? get title => _title;
  String? get subtitle => _subtitle;
  List<String>? get authors => _authors;
  String? get publishedDate => _publishedDate;
  List<IndustryIdentifiers>? get industryIdentifiers => _industryIdentifiers;
  ReadingModes? get readingModes => _readingModes;
  num? get pageCount => _pageCount;
  String? get printType => _printType;
  num? get averageRating => _averageRating;
  num? get ratingsCount => _ratingsCount;
  String? get maturityRating => _maturityRating;
  bool? get allowAnonLogging => _allowAnonLogging;
  String? get contentVersion => _contentVersion;
  ImageLinks? get imageLinks => _imageLinks;
  String? get language => _language;
  String? get previewLink => _previewLink;
  String? get infoLink => _infoLink;
  String? get canonicalVolumeLink => _canonicalVolumeLink;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['subtitle'] = _subtitle;
    map['authors'] = _authors;
    map['publishedDate'] = _publishedDate;
    if (_industryIdentifiers != null) {
      map['industryIdentifiers'] = _industryIdentifiers?.map((v) => v.toJson()).toList();
    }
    if (_readingModes != null) {
      map['readingModes'] = _readingModes?.toJson();
    }
    map['pageCount'] = _pageCount;
    map['printType'] = _printType;
    map['averageRating'] = _averageRating;
    map['ratingsCount'] = _ratingsCount;
    map['maturityRating'] = _maturityRating;
    map['allowAnonLogging'] = _allowAnonLogging;
    map['contentVersion'] = _contentVersion;
    if (_imageLinks != null) {
      map['imageLinks'] = _imageLinks?.toJson();
    }
    map['language'] = _language;
    map['previewLink'] = _previewLink;
    map['infoLink'] = _infoLink;
    map['canonicalVolumeLink'] = _canonicalVolumeLink;
    return map;
  }

}

class ImageLinks {
  ImageLinks({
      String? smallThumbnail,
      String? thumbnail,}){
    _smallThumbnail = smallThumbnail;
    _thumbnail = thumbnail;
}

  ImageLinks.fromJson(dynamic json) {
    _smallThumbnail = json['smallThumbnail'];
    _thumbnail = json['thumbnail'];
  }
  String? _smallThumbnail;
  String? _thumbnail;

  String? get smallThumbnail => _smallThumbnail;
  String? get thumbnail => _thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['smallThumbnail'] = _smallThumbnail;
    map['thumbnail'] = _thumbnail;
    return map;
  }

}

class ReadingModes {
  ReadingModes({
      bool? text,
      bool? image,}){
    _text = text;
    _image = image;
}

  ReadingModes.fromJson(dynamic json) {
    _text = json['text'];
    _image = json['image'];
  }
  bool? _text;
  bool? _image;

  bool? get text => _text;
  bool? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['image'] = _image;
    return map;
  }

}

class IndustryIdentifiers {
  IndustryIdentifiers({
      String? type,
      String? identifier,}){
    _type = type;
    _identifier = identifier;
}

  IndustryIdentifiers.fromJson(dynamic json) {
    _type = json['type'];
    _identifier = json['identifier'];
  }
  String? _type;
  String? _identifier;

  String? get type => _type;
  String? get identifier => _identifier;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['identifier'] = _identifier;
    return map;
  }

}