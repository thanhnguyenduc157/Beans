import 'dart:async';

import 'package:beans/generated/r.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final badgesTable = 'badges';
final challengesTable = 'challenges';
final challengeLogsTable = 'challenge_logs';
final godWordsTable = 'god_words';
final scheduleTypesTable = 'schedule_types';
final schedulesTable = 'schedules';
final targetsTable = 'targets';
final relationalCategoriesTable = 'relational_categories';
final relationalSubcategoriesTable = 'relational_subcategories';
final relationalSubcategoryDetailsTable = 'relational_subcategory_details';
final relationalItemsTable = 'relational_items';
final relationalReasonsTable = 'relational_reasons';
final relationalItemReasonsTable = 'relational_item_reasons';
final usersTable = 'users';

class DatabaseProvider {
  static final dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    final pathDB = join(await getDatabasesPath(), 'beans.db');
    print(pathDB);
    return openDatabase(
      pathDB,
      onCreate: initDB,
      onUpgrade: onUpgrade,
      version: 1,
    );
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    final sqls = [
      createTableBadges(),
      createTableChallenges(),
      createTableChallengeLogs(),
      createTableGodWords(),
      createTableScheduleTypes(),
      createTableSchedules(),
      createTableRelationalCategories(),
      createTableRelationalSubcategories(),
      createTableRelationalSubcategoryDetails(),
      createTableRelationalItems(),
      createTableRelationalReasons(),
      createTableRelationalItemReasons(),
      createTableTargets(),
      createTableUsers(),
      seedChallenges(),
      seedCategories(),
      seedSubcategories(),
      seedSubcategoryDetails(),
      seedReasons(),
    ];

    final batch = database.batch();

    for (var sql in sqls) {
      batch.execute(sql);
    }

    await batch.commit();
  }

  String createTableBadges() {
    return '''
        CREATE TABLE $badgesTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        received_at TEXT
        );
        ''';
  }

  String createTableChallenges() {
    return '''
      CREATE TABLE $challengesTable (
        id INTEGER PRIMARY KEY,
        name TEXT
        );
        ''';
  }

  String createTableChallengeLogs() {
    return '''
      CREATE TABLE $challengeLogsTable (
        id INTEGER PRIMARY KEY,
        challenge_id INTEGER,
        is_done INTEGER,
        created_at TEXT,
        due_at TEXT
        );
    ''';
  }

  String createTableGodWords() {
    return '''
        CREATE TABLE $godWordsTable (
        id INTEGER PRIMARY KEY,
        word TEXT
        );
    ''';
  }

  String createTableSchedules() {
    return '''
        CREATE TABLE $schedulesTable (
        id INTEGER PRIMARY KEY,
        schedule_type_id INTEGER,
        description TEXT,
        location TEXT,
        time TEXT
        );
    ''';
  }

  String createTableScheduleTypes() {
    return '''
        CREATE TABLE $scheduleTypesTable (
        id INTEGER PRIMARY KEY,
        name TEXT
        );
    ''';
  }

  String createTableRelationalCategories() {
    return '''
        CREATE TABLE $relationalCategoriesTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        icon TEXT
        );
    ''';
  }

  String createTableRelationalSubcategories() {
    return '''
        CREATE TABLE $relationalSubcategoriesTable (
        id INTEGER PRIMARY KEY,
        relational_category_id INTEGER,
        name TEXT,
        description TEXT
        );
    ''';
  }

  String createTableRelationalSubcategoryDetails() {
    return '''
        CREATE TABLE $relationalSubcategoryDetailsTable (
        id INTEGER PRIMARY KEY,
        relational_subcategory_id INTEGER,
        description TEXT
        );
    ''';
  }

  String createTableRelationalItems() {
    return '''
        CREATE TABLE $relationalItemsTable (
        id INTEGER PRIMARY KEY,
        created_at TEXT ,
        relational_category_id INTEGER,
        relational_subcategory_id INTEGER,
        relational_subcategory_detail_id INTEGER,
        is_grateful INTEGER,
        is_other INTEGER DEFAULT 0,
        name TEXT,
        is_Confess INTEGER DEFAULT 0);
        ''';
  }

  String createTableRelationalReasons() {
    return '''
 CREATE TABLE $relationalReasonsTable (
        id INTEGER PRIMARY KEY,
        relational_category_id INTEGER,
        relational_subcategory_id INTEGER,
        relational_subcategory_detail_id INTEGER,
        is_grateful INTEGER,
        is_other INTEGER DEFAULT 0,
        name TEXT
        );
    ''';
  }

  String createTableRelationalItemReasons() {
    return '''
     CREATE TABLE $relationalItemReasonsTable (
        id INTEGER PRIMARY KEY,
        relational_reason_id INTEGER,
        relational_item_id INTEGER
        );
    ''';
  }

  String createTableTargets() {
    return '''
        CREATE TABLE $targetsTable (
        id INTEGER PRIMARY KEY,
        green_count INTEGER,
        black_count INTEGER,
        due_at TEXT
        );
    ''';
  }

  String createTableUsers() {
    return '''
        CREATE TABLE $usersTable (
        id INTEGER PRIMARY KEY,
        current_challenge_log_id INTEGER,
        name TEXT,
        pin TEXT,
        bod TEXT,
        green_count INTEGER,
        black_count INTEGER,
        time_left_for_challenge TEXT,
        email TEXT
        );
    ''';
  }

  String seedChallenges() {
    return '''
    INSERT INTO $challengesTable (name)
    VALUES
    ("Mời 1 người kém may mắn 1 phần ăn"),
    ("Mời nước 1 người bất kì"),
    ("Tặng người khó khăn 1 chiếc áo"),
    ("Cảm ơn người giúp đỡ bạn"),
    ("Nói xin lỗi khi bản thân làm việc sai"),
    ("Đề nghị giúp đỡ ai đó"),
    ("Thăm viếng người neo đơn, bệnh tật"),
    ("Gởi 1 món quà nhỏ tới ai đó"),
    ("Cười và cảm ơn người phục vụ bạn"),
    ("Hướng dẫn ai đó với sự kiên nhẫn"),
    ("Khen người khác với sự chân thành"),
    ("Trước khi phê phán, hãy nói về mặt tốt"),
    ("Gửi tấm thiệp với lời chúc hoặc cảm ơn"),
    ("Nói với ai đó tại sao bạn quý họ"),
    ("Hi sinh 1 điều nhỏ bé cho người khác"),
    ("Cầu nguyện cho bản thân và 2 người khác"),
    ("Tỏ lòng biết ơn với ông bà/ cha mẹ"),
    ("Suy nghĩ kĩ trước khi phê phán ai đó"),
    ("Viết ra 3 điểm tốt của người làm bạn buồn"),
    ("Làm lành với người mà bạn đang oán hờn"),
    ("Cho đi 5 nụ cười trong ngày hôm nay"),
    ("Lập 1 danh sách về 5 ưu điểm của mình"),
    ("Gửi hoa cho 1 người thân yêu"),
    ("Chia sẻ chuyện buồn của mình với người khác"),
    ("Tình nguyện giúp đỡ 1 người lạ trên đường"),
    ("Bất ngờ đến thăm ai đó"),
    ("An ủi 1 người đang buồn mà bạn biết"),
    ("Gởi 1 tấm thiệp động viên tới 1 người bạn"),
    ("Nấu 1 bữa ăn cho gia đình"),
    ("Cầu nguyện cho người bạn không thích"),
    ("Gởi 1 món quà nhỏ tới người bạn ghét"),
    ("Lắng nghe ai đó tâm sự"),
    ("Viết lại một kỉ niệm khiến bạn vui"),
    ("Nhắn tin cảm ơn 1 người đã làm bạn vui"),
    ("Cảm ơn người thầy cũ, người bạn cũ"),
    ("Hỏi thăm người đang đau ốm"),
    ("Tip cho người đã phục vụ bạn"),
    ("Viết 1 danh sách 3 điều bạn đang biết ơn"),
    ("Suy nghĩ kĩ trước khi nói trong 24 giờ tới"),
    ("Cám ơn với sự chân thành"),
    ("Ôm 1 người thân yêu nào đó lâu 1 chút"),
    ("Tập thể dục ít nhất 15 phút trong 24 giờ tới"),
    ("Đọc 3 câu lời Chúa trong ngày hôm nay"),
    ("Khen ngợi 3 người trong ngày hôm nay"),
    ("Dán lên cửa phòng điều bạn muốn thay đổi về bản thân"),
    ("Tự đánh giá mục tiêu bạn đã đặt ra năm nay"),
    ("Cầu nguyện cho 3 người khác và thế giới"),
    ("Ghé nhà thờ và cầu nguyện 5 phút hôm nay"),
    ("Cầu nguyện trước mỗi bữa ăn trong ngày"),
    ("Dành 10 phút thinh lặng, 2 lần trong 24h tới"),
    ("Cảm tạ Chúa vì người thân yêu trong cuộc đời bạn"),
    ("Cầu nguyện cho sự an lành của thế giới"),
    ("Tặng đi món đồ bạn ít dùng đến"),
    ("Bỏ đi 1 cơn giận đang bám lấy bạn"),
    ("Ăn thức ăn tốt cho sức khoẻ"),
    ("Ăn 1 bữa ngon và tốt cho sức khoẻ"),
    ("Dành thời gian để vui chơi cùng trẻ nhỏ"),
    ("Ủng hộ cho người buôn nhỏ lẻ"),
    ("Xin lỗi hoặc cảm ơn con/cháu bạn"),
    ("Ghi lại khoảnh khắc khiến bạn bình yên"),
    ("Quyết định tha thứ và không nhắc lỗi ai đó"),
    ("'Tôi là người giàu lòng nhân ái'. Nói ra và sống điều đó"),
    ("Tự tặng cho mình 1 món quà"),
    ("Hỏi thăm một người mà bạn lâu rồi không gặp"),
    ("Dũng cảm nói ra 1 sự thật mà bạn đang giấu."),
    ("Hôm nay, thay vì la mắng, hãy khuyên bảo"),
    ("Trong 24 giờ tới, tự chủ, không nóng giận"),
    ("Trong 24 giờ tới, hãy nói lời tha thứ"),
    ("Trong 24 giờ tới, hãy nói lời yêu thương"),
    ("Làm quen với 1 người bạn mới"),
    ("Tặng đi 1 món đồ mà bạn từng rất thích"),
    ("Trong 24 giờ tới hãy hoàn thành ít nhất 1 công việc."),
    ("Nghe lại 1 bài hát mà bạn từng rất yêu thích"),
    ("Đi ngủ trước 10 giờ tối"),
    ("Giúp đỡ người yếu hơn"),
    ("Nói lời giải hoà trước"),
    ("Tha thứ trước"),
    ("Lể phép với người lớn"),
    ("Hỏi thăm một người cậy dựa vào bạn"),
    ("Chở ai đó đi/ về"),
    ("Cho đi một thứ mà bạn không dùng nữa"),
    ("Nhường ai đó đi trước"),
    ("Dành thời gian cho người lớn tuổi"),
    ("Nói với ai đó về nỗi buồn, nỗi sợ của mình"),
    ("Cho 1 dịch vụ hay sản phẩm 1 đánh giá tốt"),
    ("Hãy đi dạo 15ph hoặc hơn"),
    ("Viết cho mình của tương lai 1 điều tốt đẹp"),
    ("Thử 1 món ăn mới"),
    ("Rửa chén cho ai đó"),
    ("Hỏi ai đó về cuộc sống của họ và lắng nghe"),
    ("Làm bánh và tặng mọi người"),
    ("Học một cái gì đó mới"),
    ("Bắt đầu một thói quen tốt"),
    ("Lắng nghe ai đó thật chăm chú"),
    ("Nhớ về 1 khoảng thời gian đẹp"),
    ("Di chuyển bằng phương tiện không thả khói"),
    ("Viết thư tay cho ai đó"),
    ("Chia sẻ điều tốt đẹp của bạn với người khác"),
    ("Chia sẻ bất cứ thứ gì"),
    ("Nhặt rác bạn gặp phải và bỏ vào nơi quy định"),
    ("Chạy bộ"),
    ("Tổ chức tiệc bất ngờ"),
    ("Đến hay về đúng giờ"),
    ("Giữ đúng hẹn"),
    ("Hỏi kinh nghiệm từ người lớn tuổi hơn"),
    ("Nói với ai đó lý do họ quan trọng với bạn"),
    ("Mang cho ai đó 1 ly nước"),
    ("Mua sản phẩm của Việt Nam"),
    ("Đóng góp cho 1 quỹ từ thiện nào đó"),
    ("Bước ra khỏi vùng an toàn của bạn"),
    ("Dành thời gian chơi với thú vật"),
    ("Cười và nhường ai đó trong lúc kẹt xe"),
    ("Mua hoa cho ai đó"),
    ("Nhắc ai đó nhớ là bạn quý mến họ"),
    ("Không dùng mạng xã hội hôm nay"),
    ("Chia sẻ với ai đó bài hát bạn thích"),
    ("Chỉ dẫn cho người bé tuổi hơn"),
    ("Viết lại 1 bài học mà bạn còn nhớ"),
    ("Ngắm bình minh/ hoàng hôn"),
    ("Làm công tác tình nguyện"),
    ("Tham gia hoạt động cộng đồng"),
    ("Trả tiền cho bữa ăn của ai đó"),
    ("Dọn dẹp phòng ngủ, bàn làm việc"),
    ("Dọn dẹp máy tính"),
    ("Làm hơn những gì bạn được yêu cầu"),
    ("Nói với ai đó bạn ngưỡng mộ họ"),
    ("Giữ thinh lặng trong 5 phút"),
    ("Hát 1 bài"),
    ("Chậm lại và thở sâu"),
    ("Cười với ai đó"),
    ("Giữ cửa cho ai đó đi vào/ ra"),
    ("Hoà mình với thiên nhiên"),
    ("Tìm hiểu một văn hoá, tôn giáo khác"),
    ("Tìm hiểu về lí do ai đó hành động khác bạn"),
    ("Dứt khoát nói 'KHÔNG' với điều xấu"),
    ("Làm 1 điều tốt bất kì"),
    ("Không tìm cách thắng trong 1 cuộc cãi vã"),
    ("Tìm cách hiểu đối phương khi tranh luận"),
    ("Rủ ai đó bạn thích đi ăn"),
    ("Đỡ cho ai đó đang mang vác nặng"),
    ("Bắt đầu làm việc mà bạn còn trần trừ"),
    ("Nói chuyện với người bị bỏ rơi"),
    ("Tái chế"),
    ("Không thải ra nhựa trong hôm nay"),
    ("Động viên ai đó"),
    ("Chúc phúc cho người tổn thương bạn"),
    ("Dậy sớm để làm việc bạn đang muốn làm"),
    ("Ăn chay"),
    ("Tiết kiệm điện, nước"),
    ("Trồng cây xanh"),
    ("Chỉ dùng điện thoại 30 phút trong 24h tới"),
    ("Viết thư tay hay gởi thiệp xin lỗi ai đó"),
    ("Mời ai đó 1 ly trà sữa/ ly chè"),
    ("Nhận lỗi của mình và khiêm tốn khắc phục.");
    ''';
  }

  String seedCategories() {
    return '''
    INSERT INTO $relationalCategoriesTable (id, name, icon)
    VALUES
    (1, "Yêu Chúa", "${R.ic_god}"),
    (2, "Yêu Mình", "${R.ic_myself}"),
    (3, "Yêu Người", "${R.ic_other_guys}");
    ''';
  }

  String seedSubcategories() {
    return '''
    INSERT INTO $relationalSubcategoriesTable (id, relational_category_id, name, description)
    VALUES
    (1, 1, "Thờ phượng Chúa", "- Điều răn 1 -"),
    (2, 1, "Tôn vinh Danh Chúa","- Điều răn 2 -"),
    (3, 1, "Thánh hóa ngày của Chúa", "- Điều răn 3 -"),

    (4, 2, "Sức khoẻ và mạng sống","- Điều răn 5 -"),
    (5, 2, "Cam kết yêu thương", "- Điều răn 6 -"),
    (6, 2, "Công bằng và của cải", "- Điều răn 7 & 10 -"),
    (7, 2, "Sự Thật và Danh Dự", "- Điều răn 8 -"),

    (8, 3, "Yêu ông bà, cha mẹ và đất nước", "- Điều răn 4 -"),
    (9, 3, "Mạng sống và phẩm giá","- Điều răn 5 -"),
    (10, 3, "Cam kết yêu thương", "- Điều răn 6 & 9 -"),
    (11, 3, "Công bằng và của cải", "- Điều răn 7 & 10 -"),
    (12, 3, "Sự Thật và Danh Dự", "- Điều răn 8 -");
    ''';
  }

  String seedSubcategoryDetails() {
    return '''
    INSERT INTO $relationalSubcategoryDetailsTable (id, relational_subcategory_id, description)
    VALUES
    (1, 1, "Đức Tin"),
    (2, 1, "Đức Cậy"),
    (3, 1, "Đức Mến"),

    (4, 2, "Danh Chúa"),

    (5, 3, "Ngày Chúa Nhật"),

    (6, 4, "Sức khỏe của bản thân"),
    (7, 4, "Sự sống của tôi"),

    (8, 5, "Khiết tịnh"),

    (9, 6, "Công bằng với chính mình"),
    (10, 6, "Của cải vật chất."),

    (11, 7, "Trung thực với chính mình"),
    (12, 7, "Bảo vệ danh dự của mình"),

    (13, 8, "Yêu ông bà và cha mẹ"),
    (14, 8, "Yêu con cháu"),
    (15, 8, "Yêu đất nước & dân tộc"),

    (16, 9, "Sự sống của người khác"),
    (17, 9, "Phẩm giá và quyền bình đẳng của người khác"),

    (18, 10, "Khiết tịnh"),
    (19, 10, "Hôn nhân"),

    (20, 11, "Đối với của cải của người khác"),
    (21, 11, "Đối với tài sản của công"),
    (22, 11, "Công bằng trong yêu thương"),

    (23, 12, "Sống trung thực với tha nhân"),
    (24, 12, "Bảo vệ danh dự của tha nhân ");
    ''';
  }

  String seedReasons() {
    return '''
    INSERT INTO $relationalReasonsTable (relational_category_id, relational_subcategory_id, relational_subcategory_detail_id, is_grateful, name)
    VALUES
    (1, 1, 1, 1, "Tôi được biết 1 Thiên Chúa duy nhất, là Tình Yêu."),
    (1, 1, 1, 1, "Lòng Tin của tôi mang lại cho tôi nhiều ơn phúc."),
    (1, 1, 1, 1, "Mối liên hệ của tôi với Chúa rất bền chặt."),
    (1, 1, 1, 0, "Tôi tin vào bói toán, bùa ngải, đạo giáo khác."),
    (1, 1, 1, 0, "Tôi ngờ vực, âu lo vì chưa tin Chúa."),
    (1, 1, 1, 0, "Tôi không tìm hiểu, đào sâu đức tin."),
    (1, 1, 2, 1, "Sau khi cầu nguyện, tôi có sức mạnh làm mọi việc."),
    (1, 1, 2, 1, "Khi cầu nguyện, tôi được bình an."),
    (1, 1, 2, 1, "Chúa luôn đồng hành cùng tôi lúc gian truân."),
    (1, 1, 2, 0, "Tôi chưa làm việc cùng Chúa sau khi cầu nguyện."),
    (1, 1, 2, 0, "Tôi dễ chán nản, buông xuôi khi gặp khó khăn."),
    (1, 1, 2, 0, "Tôi ráng sức dựa vào bản thân mà quên có Chúa."),
    (1, 1, 3, 1, "Tình yêu Chúa dành cho tôi vượt trên mọi sự."),
    (1, 1, 3, 1, "Tôi biết yêu mến Chúa hết lòng và hết sức."),
    (1, 1, 3, 1, "Tôi học được cách yêu anh em mình."),
    (1, 1, 3, 0, "Tôi phủ nhận tình yêu Chúa trong cuộc đời này."),
    (1, 1, 3, 0, "Tôi yêu mến tiền, danh vọng hơn Chúa."),
    (1, 1, 3, 0, "Tôi chưa yêu anh em mình."),
    (1, 2, 4, 1, "Được gọi là người Kitô Hữu khiến tôi tự hào."),
    (1, 2, 4, 1, "Danh Chúa giúp tôi kiên vững trong mọi việc."),
    (1, 2, 4, 1, "Danh Chúa là niềm tin, niềm hi vọng của tôi."),
    (1, 2, 4, 0, "Tôi xấu hổ khi tuyên xưng Chúa."),
    (1, 2, 4, 0, "Tôi dùng Danh Chúa làm điều xấu, lừa đảo."),
    (1, 2, 4, 0, "Tôi thề thốt, gọi Danh Chúa cách bất xứng."),
    (1, 3, 5, 1, "Có ngày Chúa Nhật để thờ phượng Chúa."),
    (1, 3, 5, 1, "Có ngày Chúa Nhật để nghỉ ngơi, giải trí."),
    (1, 3, 5, 1, "Ngày Chúa Nhật để lo cho gia đình, cộng đồng."),
    (1, 3, 5, 0, "Tôi bỏ lễ Chúa Nhật."),
    (1, 3, 5, 0, "Tôi không tham dự lễ tích cực và trọn vẹn"),
    (1, 3, 5, 0, "Tôi làm mất niềm vui, sự nghỉ ngơi ngày Chúa Nhật."),
    (2, 4, 6, 1, "Tôi được khỏe mạnh."),
    (2, 4, 6, 1, "Tôi có điều kiện tập luyện, bồi bổ sức khỏe."),
    (2, 4, 6, 1, "Tôi có thời gian thư giãn, giải trí."),
    (2, 4, 6, 0, "Tôi ham vui, không bảo vệ sức khoẻ."),
    (2, 4, 6, 0, "Tôi không rèn luyện, nâng cao sức khỏe."),
    (2, 4, 6, 0, "Tôi quá lao tâm, lao lực, không nghỉ ngơi hợp lý."),
    (2, 4, 7, 1, "Tôi được sống và sống dồi dào."),
    (2, 4, 7, 1, "Tôi có điều kiện phát triển sự sống của mình."),
    (2, 4, 7, 1, "Tôi có trách nhiệm với cuộc sống của mình."),
    (2, 4, 7, 0, "Tôi từng tự sát hoặc có ý định tự sát."),
    (2, 4, 7, 0, "Tôi lãng phí sự sống, không phát triển nó."),
    (2, 4, 7, 0, "Tôi vô trách nhiệm với sự sống của mình."),
    (2, 5, 8, 1, "Tôi hài lòng với giới tính và cơ thể mình."),
    (2, 5, 8, 1, "Tôi biết giữ mình trong sạch, đứng đắn."),
    (2, 5, 8, 1, "Tôi làm chủ bản năng tính dục của mình."),
    (2, 5, 8, 0, "Tôi chối bỏ và căm ghét cơ thể mình"),
    (2, 5, 8, 0, "Tôi xem và tuyên truyền văn hoá phẩm đồi truỵ"),
    (2, 5, 8, 0, "Tôi không biết làm chủ tính dục của mình"),
    (2, 6, 9, 1, "Tôi biết sống hài hòa với chính mình."),
    (2, 6, 9, 1, "Tôi biết bao dung với chính mình."),
    (2, 6, 9, 1, "Tôi biết tha thứ cho chính mình."),
    (2, 6, 9, 0, "Tôi quá khắt khe với chính mình."),
    (2, 6, 9, 0, "Tôi tham ăn, dễ dãi với chính mình."),
    (2, 6, 9, 0, "Tôi không tha thứ cho lỗi lầm của mình."),
    (2, 6, 10, 1, "Công sức lao động của tôi tạo ra của cải."),
    (2, 6, 10, 1, "Tôi được tặng hay thừa kế của cải."),
    (2, 6, 10, 1, "Tôi biết dùng hợp lý & phát triển tài sản của mình."),
    (2, 6, 10, 0, "Tôi không lao động tạo ra tài sản công chính."),
    (2, 6, 10, 0, "Tôi không gìn giữ tài sản được kế thừa."),
    (2, 6, 10, 0, "Tôi dùng tài sản không hợp lý (quá hà tiện/ phung phí)."),
    (2, 7, 11, 1, "Tôi biết điểm mạnh của bản thân."),
    (2, 7, 11, 1, "Tôi nhận ra điểm yếu của mình."),
    (2, 7, 11, 1, "Tôi chấp nhận mình với cái hay, cái dở."),
    (2, 7, 11, 0, "Tôi kiêu ngạo vì điểm mạnh của mình."),
    (2, 7, 11, 0, "Tôi quá tự ti với điểm yếu của mình."),
    (2, 7, 11, 0, "Tôi không thành thật với chính mình."),
    (2, 7, 12, 1, "Tôi ý thức được giá trị của mình."),
    (2, 7, 12, 1, "Tôi biết bảo vệ danh dự của mình."),
    (2, 7, 12, 1, "Tôi có điều kiện để phát huy giá trị của mình."),
    (2, 7, 12, 0, "Tôi chưa ý thức được giá trị của mình."),
    (2, 7, 12, 0, "Tôi hèn nhát, không bảo vệ danh dự của mình."),
    (2, 7, 12, 0, "Tôi lười nhác, không muốn phát triển bản thân."),
    (3, 8, 13, 1, "Gia đình tôi khoẻ mạnh, hạnh phúc."),
    (3, 8, 13, 1, "Ông bà, cha mẹ yêu thương, giáo dục tôi."),
    (3, 8, 13, 1, "Tôi hiểu, kính trọng ông bà, cha mẹ."),
    (3, 8, 13, 0, "Tôi trách móc, xấu hổ với gia đình mình."),
    (3, 8, 13, 0, "Tôi hay cãi lời ông bà cha mẹ."),
    (3, 8, 13, 0, "Tôi không thảo hiếu với ông bà cha mẹ."),
    (3, 8, 14, 1, "Tôi được phúc làm cha mẹ, ông bà, chú bác."),
    (3, 8, 14, 1, "Tôi đủ kiến thức, yêu mến để giáo dục con cháu."),
    (3, 8, 14, 1, "Con cháu tôi lành mạnh về thể xác, tinh thần."),
    (3, 8, 14, 0, "Tôi chưa là tấm gương sáng cho con cháu."),
    (3, 8, 14, 0, "Tôi chưa giáo dục con cháu."),
    (3, 8, 14, 0, "Tôi đánh phạt con cháu cách phản giáo dục"),
    (3, 8, 15, 1, "Đất nước tôi giàu tài nguyên và xinh đẹp."),
    (3, 8, 15, 1, "Đất nước tôi được bình yên & tự do."),
    (3, 8, 15, 1, "Tôi đủ can đảm để bênh vực người bị áp bức."),
    (3, 8, 15, 0, "Tôi xả rác, phá hoại thiên nhiên, môi trường."),
    (3, 8, 15, 0, "Tôi thiếu tôn trọng pháp luật, sự công bằng, tự do."),
    (3, 8, 15, 0, "Tôi chưa can đảm bênh vực người bị áp bức."),
    (3, 9, 16, 1, "Gia đình, bạn bè tôi được bình an, khoẻ mạnh."),
    (3, 9, 16, 1, "Tôi được cộng tác để tạo nên sự sống mới."),
    (3, 9, 16, 1, "Anh em tôi bảo vệ sự sống, môi trường."),
    (3, 9, 16, 0, "Tôi đánh đập, làm người khác bị thương."),
    (3, 9, 16, 0, "Tôi trực tiếp hay cộng tác vào việc phá thai."),
    (3, 9, 16, 0, "Tôi giết người hoặc có ý định, đe doạ giết người."),
    (3, 9, 17, 1, "Con người được mang hình ảnh của Chúa."),
    (3, 9, 17, 1, "Mọi người đều bình đẳng bất kể màu da, giới tính, địa vị."),
    (3, 9, 17, 1, "Mỗi người có vai trò quan trọng riêng trong xã hội."),
    (3, 9, 17, 0, "Tôi lăng mạ, chửi bới người khác."),
    (3, 9, 17, 0, "Tôi khinh thường người khác."),
    (3, 9, 17, 0, "Tôi xét đoán người khác."),
    (3, 10, 18, 1, "Mỗi giới tính đóng vai trò quan trọng riêng."),
    (3, 10, 18, 1, "Trẻ em phải được bảo vệ và yêu thương."),
    (3, 10, 18, 1, "Tôi tôn trọng giới tính, quyền riêng tư người khác."),
    (3, 10, 18, 0, "Tôi đùa cợt chế giễu giới tính người khác."),
    (3, 10, 18, 0, "Tôi lạm dụng tình dục trẻ vị thành niên."),
    (3, 10, 18, 0, "Tôi quấy rối, xâm phạm tình dục người khác."),
    (3, 10, 19, 1, "Tôi có 1 người bạn đời chung thuỷ."),
    (3, 10, 19, 1, "Bạn đời của tôi sống bao dung."),
    (3, 10, 19, 1, "Con tôi được nuôi dạy trong luân lý Công Giáo."),
    (3, 10, 19, 0, "Tôi ngoại tình, có tư tưởng ngoại tình."),
    (3, 10, 19, 0, "Tôi thiếu quan tâm và thờ ơ với gia đình."),
    (3, 10, 19, 0, "Tôi độc tài và bạo hành gia đình mình."),
    (3, 11, 20, 1, "Nhiều người lao động tạo ra giá trị đẹp cho đời."),
    (3, 11, 20, 1, "Anh em tôi đối xử công bằng với tôi."),
    (3, 11, 20, 1, "Anh em tôi chia sẻ và dạy tôi tinh thần sẻ chia."),
    (3, 11, 20, 0, "Tôi trộm cắp, lừa đảo của cải."),
    (3, 11, 20, 0, "Tôi gian lận, tham nhũng."),
    (3, 11, 20, 0, "Tôi ghen ghét, tranh chấp với người khác."),
    (3, 11, 21, 1, "Những cơ sở hạ tầng tốt đẹp tôi sử dụng."),
    (3, 11, 21, 1, "Môi trường sạch đẹp Chúa ban."),
    (3, 11, 21, 1, "Những hoạt động, nghiên cứu vì môi trường."),
    (3, 11, 21, 0, "Tôi lạm dụng, lãng phí, phá hoại của công."),
    (3, 11, 21, 0, "Tôi gây ô nhiễm và hủy hoại môi trường."),
    (3, 11, 21, 0, "Tôi thờ ơ với những hoạt động vì môi trường."),
    (3, 11, 22, 1, "Anh em tôi tha thứ cho lỗi lầm của tôi."),
    (3, 11, 22, 1, "Anh em tôi dành thời gian cho tôi khi tôi cần."),
    (3, 11, 22, 1, "Anh em tôi tặng tôi món quà, đãi tôi ăn."),
    (3, 11, 22, 0, "Tôi giận ghét người khác."),
    (3, 11, 22, 0, "Tôi trả thù, ăn miếng trả miếng."),
    (3, 11, 22, 0, "Tôi không cho không ai cái gì."),
    (3, 12, 23, 1, "Anh em tôi sống trung thực với nhau."),
    (3, 12, 23, 1, "Anh em tôi động viên nhau sống sự thật."),
    (3, 12, 23, 1, "Môi trường trung thực cho tôi sự bình an."),
    (3, 12, 23, 0, "Tôi nói dối, khoác lác."),
    (3, 12, 23, 0, "Tôi bao che cho sự sai trái."),
    (3, 12, 23, 0, "Tôi nói giảm, nói tránh, bóp méo sự thật."),
    (3, 12, 24, 1, "Anh em tôi nói và làm có uy tín."),
    (3, 12, 24, 1, "Anh em tôi biết bảo vệ danh dự của họ."),
    (3, 12, 24, 1, "Anh em tôi nhận định có nguyên căn."),
    (3, 12, 24, 0, "Tôi nói xấu sau lưng."),
    (3, 12, 24, 0, "Tôi vu khống cho người khác."),
    (3, 12, 24, 0, "Tôi suy diễn, kết luận không căn cứ.");
    ''';
  }
}
