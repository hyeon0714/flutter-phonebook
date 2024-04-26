import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'PersonVo.dart';

//StatelessWidget ->  정적인 페이지
//StatefulWidget  ->  동적인 페이지

class ex04 extends StatelessWidget {
  const ex04({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("수정"),
      ),
      body: Container(
        color: Color(0xff998899),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: _read(),
      ),
    );
  }
}

//변화를 감시
class _read extends StatefulWidget {
  const _read({super.key});

  @override
  State<_read> createState() => _readState();
}

//실제 코드가 할일(통신, 데이터 적용)
class _readState extends State<_read> {
  //단축기 alt+insert

  //변수
  late Future<PersonVo> personVo; //late를 써서 늦게 작동 시키기.... future로 담은걸 가져와....
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  //초기화함수
  @override
  void initState() {
    super.initState();
    //추가코드  //데이터 불러오기 메소드 호출
    print("initState(): 데이터 가져오기 전");
  }

  //라우터로 전달받은 personId

  //화면그리기
  @override
  Widget build(BuildContext context) {
    print("build(): 그리기 작업");

    late final args = ModalRoute.of(context)!.settings.arguments as Map;
    final personId = args['personId'];

    print(personId);

    personVo = getPersonByNo(personId);
    print("initState(): 데이터 가져오기 후");

    return FutureBuilder(
      future: personVo, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else {
          //데이터가 있으면
          //_nameController.text = snapshot.data!.name;
          return Form(
              child: Column(
            children: [
              Row(
                children: [
                  Container(
                    color: Color(0xffffffff),
                    child: Text("번호"),
                    width: 50,
                    alignment: Alignment.center,
                  ),
                  Container(
                    color: Color(0xffffffff),
                    width: 200,
                    child: Text('${snapshot.data!.personId}'),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    color: Color(0xffffffff),
                    child: Text("이름"),
                    width: 50,
                    alignment: Alignment.center,
                  ),
                  Container(
                      color: Color(0xffffffff),
                      width: 200,
                      child: TextFormField(
                        controller: _nameController,
                        decoration:
                            InputDecoration(hintText: "${snapshot.data!.name}"),
                      )
                      /*Text("${snapshot.data!.name}"),*/
                      ),
                ],
              ),
              Row(
                children: [
                  Container(
                    color: Color(0xffffffff),
                    child: Text("번호"),
                    width: 50,
                    alignment: Alignment.center,
                  ),
                  Container(
                      color: Color(0xffffffff),
                      width: 200,
                      child: TextFormField(
                        controller: _hpController,
                        decoration:
                            InputDecoration(hintText: "${snapshot.data!.hp}"),
                      )
                      /*Text("${snapshot.data!.name}"),*/
                      ),
                ],
              ),
              Row(
                children: [
                  Container(
                    color: Color(0xffffffff),
                    child: Text("회사"),
                    width: 50,
                    alignment: Alignment.center,
                  ),
                  Container(
                      color: Color(0xffffffff),
                      width: 200,
                      child: TextFormField(
                        controller: _companyController,
                        decoration: InputDecoration(
                            hintText: "${snapshot.data!.company}"),
                      )
                      /*Text("${snapshot.data!.name}"),*/
                      ),
                ],
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      print("전송");
                      _modify("${snapshot.data!.personId}");
                    },
                    child: Text("수정")),
              ),
            ],
          ));
        } // 데이터가있으면
      },
    );
    ;
  }

  //3번의 데이터 가져오기
  Future<PersonVo> getPersonByNo(i) async {
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.get(
        'http://localhost:9090/api/list/${i}',
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경
        //print(response.data["result"]); //map에서 꺼내는법
        //print(response.data["apiData"]["personId"]);
        return PersonVo.fromJson(response.data["apiData"]); //PersonVo에 담는다

        //return PersonVo.fromJson(response.data["apiData"]);
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }

  Future<void> _modify(i) async {
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();
      // 헤더설정:json으로 전송
      var tmp = {
        'personId': '${i}',
        'name': '${_nameController}',
        'hp': '${_hpController}',
        'company': '${_companyController}',
      };
      print(tmp);
      dio.options.headers['Content-Type'] = 'application/json';
      // 서버 요청
      final response = await dio.post(
        'http://localhost:9090/api/modify',
        data: {
          // 예시 data map->json자동변경
          'personId': '${i}',
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
        Navigator.pushNamed(context, "/list");
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
