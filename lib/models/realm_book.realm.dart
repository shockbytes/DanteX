// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_book.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmBook extends _RealmBook
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  RealmBook(
    int id, {
    String? title = '',
    String? subTitle = '',
    String? author = '',
    int pageCount = 0,
    String? publishedDate = '',
    int position = 0,
    String? isbn = '',
    String? thumbnailAddress = '',
    String? googleBooksLink = '',
    int startDate = 0,
    int endDate = 0,
    int ordinalState = 0,
    int wishlistDate = 0,
    String? language = 'NA',
    int rating = 0,
    int currentPage = 0,
    String? notes = '',
    String? summary = '',
    Iterable<RealmBookLabel> labels = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<RealmBook>({
        'title': '',
        'subTitle': '',
        'author': '',
        'pageCount': 0,
        'publishedDate': '',
        'position': 0,
        'isbn': '',
        'thumbnailAddress': '',
        'googleBooksLink': '',
        'startDate': 0,
        'endDate': 0,
        'ordinalState': 0,
        'wishlistDate': 0,
        'language': 'NA',
        'rating': 0,
        'currentPage': 0,
        'notes': '',
        'summary': '',
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'subTitle', subTitle);
    RealmObjectBase.set(this, 'author', author);
    RealmObjectBase.set(this, 'pageCount', pageCount);
    RealmObjectBase.set(this, 'publishedDate', publishedDate);
    RealmObjectBase.set(this, 'position', position);
    RealmObjectBase.set(this, 'isbn', isbn);
    RealmObjectBase.set(this, 'thumbnailAddress', thumbnailAddress);
    RealmObjectBase.set(this, 'googleBooksLink', googleBooksLink);
    RealmObjectBase.set(this, 'startDate', startDate);
    RealmObjectBase.set(this, 'endDate', endDate);
    RealmObjectBase.set(this, 'ordinalState', ordinalState);
    RealmObjectBase.set(this, 'wishlistDate', wishlistDate);
    RealmObjectBase.set(this, 'language', language);
    RealmObjectBase.set(this, 'rating', rating);
    RealmObjectBase.set(this, 'currentPage', currentPage);
    RealmObjectBase.set(this, 'notes', notes);
    RealmObjectBase.set(this, 'summary', summary);
    RealmObjectBase.set<RealmList<RealmBookLabel>>(
        this, 'labels', RealmList<RealmBookLabel>(labels));
  }

  RealmBook._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get title => RealmObjectBase.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObjectBase.set(this, 'title', value);

  @override
  String? get subTitle =>
      RealmObjectBase.get<String>(this, 'subTitle') as String?;
  @override
  set subTitle(String? value) => RealmObjectBase.set(this, 'subTitle', value);

  @override
  String? get author => RealmObjectBase.get<String>(this, 'author') as String?;
  @override
  set author(String? value) => RealmObjectBase.set(this, 'author', value);

  @override
  int get pageCount => RealmObjectBase.get<int>(this, 'pageCount') as int;
  @override
  set pageCount(int value) => RealmObjectBase.set(this, 'pageCount', value);

  @override
  String? get publishedDate =>
      RealmObjectBase.get<String>(this, 'publishedDate') as String?;
  @override
  set publishedDate(String? value) =>
      RealmObjectBase.set(this, 'publishedDate', value);

  @override
  int get position => RealmObjectBase.get<int>(this, 'position') as int;
  @override
  set position(int value) => RealmObjectBase.set(this, 'position', value);

  @override
  String? get isbn => RealmObjectBase.get<String>(this, 'isbn') as String?;
  @override
  set isbn(String? value) => RealmObjectBase.set(this, 'isbn', value);

  @override
  String? get thumbnailAddress =>
      RealmObjectBase.get<String>(this, 'thumbnailAddress') as String?;
  @override
  set thumbnailAddress(String? value) =>
      RealmObjectBase.set(this, 'thumbnailAddress', value);

  @override
  String? get googleBooksLink =>
      RealmObjectBase.get<String>(this, 'googleBooksLink') as String?;
  @override
  set googleBooksLink(String? value) =>
      RealmObjectBase.set(this, 'googleBooksLink', value);

  @override
  int get startDate => RealmObjectBase.get<int>(this, 'startDate') as int;
  @override
  set startDate(int value) => RealmObjectBase.set(this, 'startDate', value);

  @override
  int get endDate => RealmObjectBase.get<int>(this, 'endDate') as int;
  @override
  set endDate(int value) => RealmObjectBase.set(this, 'endDate', value);

  @override
  int get ordinalState => RealmObjectBase.get<int>(this, 'ordinalState') as int;
  @override
  set ordinalState(int value) =>
      RealmObjectBase.set(this, 'ordinalState', value);

  @override
  int get wishlistDate => RealmObjectBase.get<int>(this, 'wishlistDate') as int;
  @override
  set wishlistDate(int value) =>
      RealmObjectBase.set(this, 'wishlistDate', value);

  @override
  String? get language =>
      RealmObjectBase.get<String>(this, 'language') as String?;
  @override
  set language(String? value) => RealmObjectBase.set(this, 'language', value);

  @override
  int get rating => RealmObjectBase.get<int>(this, 'rating') as int;
  @override
  set rating(int value) => RealmObjectBase.set(this, 'rating', value);

  @override
  int get currentPage => RealmObjectBase.get<int>(this, 'currentPage') as int;
  @override
  set currentPage(int value) => RealmObjectBase.set(this, 'currentPage', value);

  @override
  String? get notes => RealmObjectBase.get<String>(this, 'notes') as String?;
  @override
  set notes(String? value) => RealmObjectBase.set(this, 'notes', value);

  @override
  String? get summary =>
      RealmObjectBase.get<String>(this, 'summary') as String?;
  @override
  set summary(String? value) => RealmObjectBase.set(this, 'summary', value);

  @override
  RealmList<RealmBookLabel> get labels =>
      RealmObjectBase.get<RealmBookLabel>(this, 'labels')
          as RealmList<RealmBookLabel>;
  @override
  set labels(covariant RealmList<RealmBookLabel> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<RealmBook>> get changes =>
      RealmObjectBase.getChanges<RealmBook>(this);

  @override
  Stream<RealmObjectChanges<RealmBook>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<RealmBook>(this, keyPaths);

  @override
  RealmBook freeze() => RealmObjectBase.freezeObject<RealmBook>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'subTitle': subTitle.toEJson(),
      'author': author.toEJson(),
      'pageCount': pageCount.toEJson(),
      'publishedDate': publishedDate.toEJson(),
      'position': position.toEJson(),
      'isbn': isbn.toEJson(),
      'thumbnailAddress': thumbnailAddress.toEJson(),
      'googleBooksLink': googleBooksLink.toEJson(),
      'startDate': startDate.toEJson(),
      'endDate': endDate.toEJson(),
      'ordinalState': ordinalState.toEJson(),
      'wishlistDate': wishlistDate.toEJson(),
      'language': language.toEJson(),
      'rating': rating.toEJson(),
      'currentPage': currentPage.toEJson(),
      'notes': notes.toEJson(),
      'summary': summary.toEJson(),
      'labels': labels.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmBook value) => value.toEJson();
  static RealmBook _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
      } =>
        RealmBook(
          fromEJson(id),
          title: fromEJson(ejson['title'], defaultValue: ''),
          subTitle: fromEJson(ejson['subTitle'], defaultValue: ''),
          author: fromEJson(ejson['author'], defaultValue: ''),
          pageCount: fromEJson(ejson['pageCount'], defaultValue: 0),
          publishedDate: fromEJson(ejson['publishedDate'], defaultValue: ''),
          position: fromEJson(ejson['position'], defaultValue: 0),
          isbn: fromEJson(ejson['isbn'], defaultValue: ''),
          thumbnailAddress:
              fromEJson(ejson['thumbnailAddress'], defaultValue: ''),
          googleBooksLink:
              fromEJson(ejson['googleBooksLink'], defaultValue: ''),
          startDate: fromEJson(ejson['startDate'], defaultValue: 0),
          endDate: fromEJson(ejson['endDate'], defaultValue: 0),
          ordinalState: fromEJson(ejson['ordinalState'], defaultValue: 0),
          wishlistDate: fromEJson(ejson['wishlistDate'], defaultValue: 0),
          language: fromEJson(ejson['language'], defaultValue: 'NA'),
          rating: fromEJson(ejson['rating'], defaultValue: 0),
          currentPage: fromEJson(ejson['currentPage'], defaultValue: 0),
          notes: fromEJson(ejson['notes'], defaultValue: ''),
          summary: fromEJson(ejson['summary'], defaultValue: ''),
          labels: fromEJson(ejson['labels'], defaultValue: const []),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmBook._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, RealmBook, 'RealmBook', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string, optional: true),
      SchemaProperty('subTitle', RealmPropertyType.string, optional: true),
      SchemaProperty('author', RealmPropertyType.string, optional: true),
      SchemaProperty('pageCount', RealmPropertyType.int),
      SchemaProperty('publishedDate', RealmPropertyType.string, optional: true),
      SchemaProperty('position', RealmPropertyType.int),
      SchemaProperty('isbn', RealmPropertyType.string, optional: true),
      SchemaProperty('thumbnailAddress', RealmPropertyType.string,
          optional: true),
      SchemaProperty('googleBooksLink', RealmPropertyType.string,
          optional: true),
      SchemaProperty('startDate', RealmPropertyType.int),
      SchemaProperty('endDate', RealmPropertyType.int),
      SchemaProperty('ordinalState', RealmPropertyType.int),
      SchemaProperty('wishlistDate', RealmPropertyType.int),
      SchemaProperty('language', RealmPropertyType.string, optional: true),
      SchemaProperty('rating', RealmPropertyType.int),
      SchemaProperty('currentPage', RealmPropertyType.int),
      SchemaProperty('notes', RealmPropertyType.string, optional: true),
      SchemaProperty('summary', RealmPropertyType.string, optional: true),
      SchemaProperty('labels', RealmPropertyType.object,
          linkTarget: 'RealmBookLabel',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class RealmBookLabel extends _RealmBookLabel
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  RealmBookLabel({
    int bookId = -1,
    String? title = '',
    String? hexColor = '',
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<RealmBookLabel>({
        'bookId': -1,
        'title': '',
        'hexColor': '',
      });
    }
    RealmObjectBase.set(this, 'bookId', bookId);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'hexColor', hexColor);
  }

  RealmBookLabel._();

  @override
  int get bookId => RealmObjectBase.get<int>(this, 'bookId') as int;
  @override
  set bookId(int value) => RealmObjectBase.set(this, 'bookId', value);

  @override
  String? get title => RealmObjectBase.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObjectBase.set(this, 'title', value);

  @override
  String? get hexColor =>
      RealmObjectBase.get<String>(this, 'hexColor') as String?;
  @override
  set hexColor(String? value) => RealmObjectBase.set(this, 'hexColor', value);

  @override
  Stream<RealmObjectChanges<RealmBookLabel>> get changes =>
      RealmObjectBase.getChanges<RealmBookLabel>(this);

  @override
  Stream<RealmObjectChanges<RealmBookLabel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<RealmBookLabel>(this, keyPaths);

  @override
  RealmBookLabel freeze() => RealmObjectBase.freezeObject<RealmBookLabel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'bookId': bookId.toEJson(),
      'title': title.toEJson(),
      'hexColor': hexColor.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmBookLabel value) => value.toEJson();
  static RealmBookLabel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return RealmBookLabel(
      bookId: fromEJson(ejson['bookId'], defaultValue: -1),
      title: fromEJson(ejson['title'], defaultValue: ''),
      hexColor: fromEJson(ejson['hexColor'], defaultValue: ''),
    );
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmBookLabel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, RealmBookLabel, 'RealmBookLabel', [
      SchemaProperty('bookId', RealmPropertyType.int),
      SchemaProperty('title', RealmPropertyType.string, optional: true),
      SchemaProperty('hexColor', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class RealmPageRecord extends _RealmPageRecord
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  RealmPageRecord(
    String? recordId, {
    int bookId = -1,
    int fromPage = 0,
    int toPage = 0,
    int timestamp = 0,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<RealmPageRecord>({
        'recordId': '',
        'bookId': -1,
        'fromPage': 0,
        'toPage': 0,
        'timestamp': 0,
      });
    }
    RealmObjectBase.set(this, 'recordId', recordId);
    RealmObjectBase.set(this, 'bookId', bookId);
    RealmObjectBase.set(this, 'fromPage', fromPage);
    RealmObjectBase.set(this, 'toPage', toPage);
    RealmObjectBase.set(this, 'timestamp', timestamp);
  }

  RealmPageRecord._();

  @override
  String? get recordId =>
      RealmObjectBase.get<String>(this, 'recordId') as String?;
  @override
  set recordId(String? value) => RealmObjectBase.set(this, 'recordId', value);

  @override
  int get bookId => RealmObjectBase.get<int>(this, 'bookId') as int;
  @override
  set bookId(int value) => RealmObjectBase.set(this, 'bookId', value);

  @override
  int get fromPage => RealmObjectBase.get<int>(this, 'fromPage') as int;
  @override
  set fromPage(int value) => RealmObjectBase.set(this, 'fromPage', value);

  @override
  int get toPage => RealmObjectBase.get<int>(this, 'toPage') as int;
  @override
  set toPage(int value) => RealmObjectBase.set(this, 'toPage', value);

  @override
  int get timestamp => RealmObjectBase.get<int>(this, 'timestamp') as int;
  @override
  set timestamp(int value) => RealmObjectBase.set(this, 'timestamp', value);

  @override
  Stream<RealmObjectChanges<RealmPageRecord>> get changes =>
      RealmObjectBase.getChanges<RealmPageRecord>(this);

  @override
  Stream<RealmObjectChanges<RealmPageRecord>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<RealmPageRecord>(this, keyPaths);

  @override
  RealmPageRecord freeze() =>
      RealmObjectBase.freezeObject<RealmPageRecord>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'recordId': recordId.toEJson(),
      'bookId': bookId.toEJson(),
      'fromPage': fromPage.toEJson(),
      'toPage': toPage.toEJson(),
      'timestamp': timestamp.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmPageRecord value) => value.toEJson();
  static RealmPageRecord _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'recordId': EJsonValue recordId,
      } =>
        RealmPageRecord(
          fromEJson(ejson['recordId'], defaultValue: ''),
          bookId: fromEJson(ejson['bookId'], defaultValue: -1),
          fromPage: fromEJson(ejson['fromPage'], defaultValue: 0),
          toPage: fromEJson(ejson['toPage'], defaultValue: 0),
          timestamp: fromEJson(ejson['timestamp'], defaultValue: 0),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmPageRecord._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, RealmPageRecord, 'RealmPageRecord', [
      SchemaProperty('recordId', RealmPropertyType.string,
          optional: true, primaryKey: true),
      SchemaProperty('bookId', RealmPropertyType.int),
      SchemaProperty('fromPage', RealmPropertyType.int),
      SchemaProperty('toPage', RealmPropertyType.int),
      SchemaProperty('timestamp', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
