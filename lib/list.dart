import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'PersonVo.dart';

class ex02 extends StatelessWidget {
  const ex02({super.key});

  //기본 레이아웃
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("list")),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        color: Color(0xff998899),
        child: _list(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, '/writeform');
      },
        child: Icon(Icons.add),),
    );
  }
}

class _list extends StatefulWidget {
  const _list({super.key});

  @override
  State<_list> createState() => _listState();
}

//사용할 일
class _listState extends State<_list> {
  //공통변수
  late Future<List<PersonVo>> pListFuture;

  //생애주기별 훅

  //초기화
  @override
  void initState() {
    super.initState();
    pListFuture = getPersonList(); //실행
  }

  //그림그릴때
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pListFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else {
          //데이터가 있으면
          return ListView.builder(
            itemCount: snapshot.data!.length, //반복될 획수(!는 null 아닐 수 있는 표현을 막아준다)
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text("${snapshot.data![index].personId}"),
                    color: Color(0xffffffff),
                    width: 50,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("${snapshot.data![index].name}"),
                    color: Color(0xffffffff),
                    width: 200,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("${snapshot.data![index].hp}"),
                    color: Color(0xffffffff),
                    width: 300,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("${snapshot.data![index].company}"),
                    color: Color(0xffffffff),
                    width: 300,
                  ),
                  IconButton(
                      onPressed: () {
                        print("이동");
                        Navigator.pushNamed(context, '/read', arguments: {
                          "personId": "${snapshot.data![index].personId}"
                        });
                      },
                      icon: Icon(Icons.arrow_forward)),

                ],
              );
            },
          );
        } // 데이터가있으면
      },
    );
  }

  //리스트 가져오기 dio통신
  Future<List<PersonVo>> getPersonList() async {
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.get(
        'http://localhost:9090/api/list',
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경
        print(response.data["apiData"]); //map에서 꺼내는법
        //print(response.data["apiData"][5]["personId"]);

        //비어있는 리스트 생성 []
        List<PersonVo> pList = [];
        for (int i = 0; i < response.data["apiData"].length; i++) {
          //map -> {}
          PersonVo personVo = PersonVo.fromJson(response.data["apiData"][i]);
          //[{}, {}, {}]
          pList.add(personVo);
        }
        print(pList);

        return pList; //PersonVo에 담는다

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
}
