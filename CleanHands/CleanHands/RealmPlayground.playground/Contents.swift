import UIKit
import RealmSwift


class DateRealm: Object {
    @objc dynamic var year = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
}

// 데이터 타입 클래스를 선언하고, 저장할 year/month/day를 각각 지정합니다.
let dateSelected = DateRealm()
dateSelected.year = "2021"
dateSelected.month = "07"
dateSelected.day = "13"
            
// Realm 가져오기
let realm = try! Realm()
 
// Realm 에 저장하기
try! realm.write {
    realm.add(dateSelected)
    realm.add(dateSelected)

}

let savedDates = realm.objects(DateRealm.self)
print(savedDates)
print(savedDates[0])
print(savedDates[1])

try! realm.write{
//    realm.delete(realm.objects(DateRealm.self))  //delete whole data
    realm.delete(realm.objects(DateRealm.self).first!)
}
print(savedDates)
