import SwiftUI

//TODO: - ToolBar Item들 네비게이션으로 다른 뷰 연결

struct MainProfileView: View {
    var body: some View {
        VStack(alignment: .leading){ //MARK: - 처음부터 끝까지 모든 요소들을 아우르는 stack.
            profileSectionView()
            Spacer()
        }
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                NavigationLink {
                    ProfileSettingView()
                } label: {
                    Image(systemName: "gearshape")
                }
                NavigationLink {
                    ProfileSettingView() //추후 Send Knock View로 변경해야함
                } label: {
                    Image(systemName: "square.and.pencil")
                }

                
            }
        }
        
    }
}

struct MainProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainProfileView()
        }
    }
}
