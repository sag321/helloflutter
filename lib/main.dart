import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: '독서실 자리 확인 & 예약',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: DokseosilSeatScreen(),
  ));
}

class DokseosilSeatScreen extends StatefulWidget {
  @override
  _DokseosilSeatScreenState createState() => _DokseosilSeatScreenState();
}

class _DokseosilSeatScreenState extends State<DokseosilSeatScreen> {
  List<bool> seatStatusList = List.generate(20, (index) => false); // 좌석 상태를 저장하는 리스트

  bool allSeatsReserved = false; // 모든 좌석이 예약되었는지 여부를 저장하는 변수

  int? reservedSeatCount; // 예약된 좌석 수를 저장하는 변수

  int? selectedSeatIndex; // 선택한 좌석의 인덱스를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('독서실 자리 확인 & 예약'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                seatStatusList = List.generate(20, (index) => false); // 좌석 상태 초기화
                allSeatsReserved = false; // 모든 좌석 예약 상태 초기화
                reservedSeatCount = 0; // 예약된 좌석 수 초기화
                selectedSeatIndex = null; // 선택한 좌석 인덱스 초기화
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '예약된 자리: ${reservedSeatCount ?? 0}개',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 좌석 수에 따라 조정할 수 있습니다.
                childAspectRatio: 1.2, // 좌석의 가로 세로 비율을 조정합니다.
              ),
              itemCount: 20, // 좌석 수
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      seatStatusList[index] = !seatStatusList[index]; // 좌석 상태를 토글합니다.

                      // 모든 좌석이 예약되었는지 확인합니다.
                      allSeatsReserved = seatStatusList.every((status) => status == true);

                      // 예약된 좌석 수를 업데이트합니다.
                      reservedSeatCount = seatStatusList.where((status) => status == true).length;

                      // 선택한 좌석의 인덱스를 저장합니다.
                      selectedSeatIndex = index;
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      seatStatusList = List.generate(20, (index) => false); // 모든 좌석 초기화
                      allSeatsReserved = false; // 모든 좌석 예약 상태 초기화
                      reservedSeatCount = 0; // 예약된 좌석 수 초기화
                      selectedSeatIndex = null; // 선택한 좌석 인덱스 초기화
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    color: seatStatusList[index] ? Colors.red : Colors.green, // 좌석 예약 상태에 따라 색상을 설정합니다.
                    child: Center(
                      child: Text(
                        '자리 ${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectedSeatIndex != null)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '선택한 자리: ${selectedSeatIndex! + 1}번',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ElevatedButton(
            child: Text('예약된 자리 보기'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservedSeatsScreen(seatStatusList),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          setState(() {
            // 모든 자리를 예약 또는 해제합니다.
            if (allSeatsReserved) {
              seatStatusList = List.generate(20, (index) => false);
              reservedSeatCount = 0; // 예약된 자리 수 초기화
              selectedSeatIndex = null; // 선택한 자리 인덱스 초기화
            } else {
              seatStatusList = List.generate(20, (index) => true);
              reservedSeatCount = 20; // 예약된 자리 수 업데이트
              selectedSeatIndex = null; // 선택한 자리 인덱스 초기화
            }

            allSeatsReserved = !allSeatsReserved; // 모든 자리 예약 상태를 토글합니다.
          });
        },
      ),
    );
  }
}

class ReservedSeatsScreen extends StatelessWidget {
  final List<bool> seatStatusList;

  ReservedSeatsScreen(this.seatStatusList);

  @override
  Widget build(BuildContext context) {
    List<int> reservedSeats = [];
    for (int i = 0; i < seatStatusList.length; i++) {
      if (seatStatusList[i]) {
        reservedSeats.add(i + 1);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('예약된 자리'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: reservedSeats.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('자리 ${reservedSeats[index]}번'),
            );
          },
        ),
      ),
    );
  }
}
