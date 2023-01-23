# FireStore Listener
Firestore Listener를 활용하여 DB 문서의 변경을 감지하고, 이를 실시간으로 처리해줄 수 있습니다.


## Code

```swift
var listener : ListenerRegistration?

func addListener() {
        listener = database.collectionGroup("ChatCell").addSnapshotListener { snapshot, error in
                // snapshot이 비어있으면 에러 출력 후 리턴
                guard let snp = snapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                // document 변경 사항에 대해 감지해서 작업 수행
                snp.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        print("added")
                        self.chatCells.append(self.fetchNewChat(newChat: diff.document))
                    case .modified:
                        print("modified")
                    case .removed:
                        print("removed")
                    }
                }
            }
    }

func removeListener() {
        guard listener != nil else {
            return
        }
        listener!.remove()
    }

```

## 참고사항
- addSnapshotListener를 통해 실시간 감지 기능을 작동시킬 수 있습니다.
    - 실시간 감지 기능이 작동되는 동안 DB의 변경사항이 생기면 이를 감지합니다.
- documentChanges를 통해 변경사항을 받을 수 있으며, 이는 세 가지 타입 중 하나에 해당합니다.
    - .added : 문서 추가
    - .modified : 문서 변경
    - .removed : 문서 삭제
- 컬렉션, 문서ID 등을 통해 실시간 감지 대상 경로를 한정할 수 있습니다.
- listener.remove() 함수를 호출하여 실시간 감지 기능을 중지할 수 있습니다.
    - remove하기 위해서는 addSnapshotListener 함수에서 리턴하는 ListenerRegistration 타입의 인스턴스를 변수에 저장해두어야합니다.
- Listener 작동 시, 기존에 있는 문서들이 새로 추가된 것으로 인식하는 문제가 있습니다.
- 문서가 추가될 때, 읽기 횟수는 새로 추가된 문서에 대해서만 증가합니다.


# 작성자
- 원태영, 정예슬
