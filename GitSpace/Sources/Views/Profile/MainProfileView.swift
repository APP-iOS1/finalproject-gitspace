import SwiftUI

//TODO: - ToolBar Item들 네비게이션으로 다른 뷰 연결

struct MainProfileView: View {
    var body: some View {
        VStack(alignment: .leading){ //MARK: - 처음부터 끝까지 모든 요소들을 아우르는 stack.
            ProfileSectionView()
				.padding(.horizontal, 10)
            Spacer()
        }
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                NavigationLink {
                    ProfileSettingView()
                } label: {
                    Image(systemName: "gearshape")
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
