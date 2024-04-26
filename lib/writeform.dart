import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ex03 extends StatelessWidget {
  const ex03({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("작성폼"),
        ),
        body: _write());
  }
}

class _write extends StatefulWidget {
  const _write({super.key});

  @override
  State<_write> createState() => _writeState();
}

class _writeState extends State<_write> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  //그리기
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        color: Color(0xff998899),
        child: Form(
          child: Container(
            color: Color(0xffffffff),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: "이름",
                          hintText: "이름을 입력하세요",
                          border: OutlineInputBorder())),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                      controller: _hpController,
                      decoration: InputDecoration(
                          labelText: "번호",
                          hintText: "번호를 입력하세요",
                          border: OutlineInputBorder())),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                      controller: _companyController,
                      decoration: InputDecoration(
                          labelText: "회사",
                          hintText: "회사번호를 입력하세요",
                          border: OutlineInputBorder())),
                ),
                ElevatedButton(
                    onPressed: () {
                      print("전송");
                      _write2();

                    },
                    child: Text("등록")),
              ],
            ),
          ),
        ));
  }

  Future<void> _write2() async {
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();
      // 헤더설정:json으로 전송
      var tmp = {
        'name': '${_nameController}',
        'hp': '${_hpController}',
        'company': '${_companyController}',
      };
      print(tmp);
      dio.options.headers['Content-Type'] = 'application/json';
      // 서버 요청
      final response = await dio.post(
        'http://localhost:9090/api/persons',

        data: {
        // 예시 data map->json자동변경
          'name': '${_nameController.text}',
          'hp': '${_hpController.text}',
          'company': '${_companyController.text}',
        },

      );
      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경
        //return PersonVo.fromJson(response.data["apiData"]);
        Navigator.pushNamed(context, '/list');
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }
}
