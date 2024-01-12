class camera {
  late int uid;
  late String loc;
  late String url;

  camera(this.uid, this.loc, this.url);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = uid;
    map['loc'] = loc;
    map['url'] = url;
    return map;
  }

  camera.fromMapObject(Map<String, dynamic> map) {
    uid = map['uid'];
    loc = map['loc'];
    url = map['url'];
  }
}
