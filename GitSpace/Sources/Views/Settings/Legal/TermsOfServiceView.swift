//
//  TermsOfServiceView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/16.
//

import SwiftUI
import WebKit

struct TermsOfServiceView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("""
These are terms prepared by **GitSpace**, which provides a service to view, manage, and chat with members of GitHub repositories.
**GitSpace** establishes and discloses the following personal information processing guidelines in order to protect the personal information of information subjects in accordance with Article 30 of the Personal Information Protection Act and to handle complaints related to this quickly and smoothly.

""")
                    .font(.footnote)
                
                Group {
                    Text("Article 1 (Purpose)")
                        .font(.headline)
                    Text(
"""
**RBG** (hereinafter referred to as the ‘Company’) uses the **GitSpace** service (hereinafter referred to as the ‘Company Service’) that the Company intends to provide. In order to protect the information (hereinafter referred to as “personal information”) of individuals (hereinafter referred to as “users” or “individuals”), the Personal Information Protection Act, Comply with relevant laws and regulations, such as the Act on Promotion of Use of Common Trust and Information Protection (hereinafter referred to as the 'Information and Communications Network Act'), In order to quickly and smoothly handle complaints related to personal information protection of users, the following We also establish a personal information processing policy (hereinafter referred to as “this policy”).

""").font(.footnote)
                    
                    Text("Article 2 (Principle of personal information processing)")
                        .font(.headline)
                    Text(
"""
In accordance with the laws related to personal information and this policy, the company may collect personal information of users, and the collected personal information may be provided to third parties only when there is an individual's consent. However, if legally compelled by the provisions of the law, etc., the company may provide the collected personal information of the user to a third party without the individual's consent in advance.

""").font(.footnote)
                    
                    Text("Article 3 (Disclosure of this policy)")
                        .font(.headline)
                    Text(
"""
**1.** The company discloses this policy through the first screen of the company homepage or a screen connected to the first screen so that users can easily check this policy at any time.
**2.** When the company discloses this policy in accordance with Paragraph 1, it uses font size, color, etc. so that users can easily check this policy.

""").font(.footnote)
                    
                    Text("Article 4 (Changes to this Policy)")
                        .font(.headline)
                    Text(
"""
**1.** This policy may be revised according to changes in privacy-related laws, guidelines, notifications, or changes in the policies or contents of the government or company services.
**2.** When the company revises this policy pursuant to Paragraph 1, it will notify you in one or more of the following ways.
     **a.** How to notify through the notice section on the first screen of the company's Internet homepage or a separate window
     **b.** How to notify users in writing, facsimile transmission, e-mail or similar methods
**3.** The company announces the notice in Paragraph 2 at least 7 days prior to the enforcement date of the revision of this policy. However, if there is a significant change in user rights, it will be notified at least 30 days in advance.

""").font(.footnote)
                    
                    Text("Article 5 (Information for membership registration and company service provision)")
                        .font(.headline)
                    Text(
"""
The company collects the following information for membership registration and service provision to users.
**1.** Required information collected: **GitHub login information**

""").font(.footnote)
                } // Group
                
                Group {
                    Text("Article 6 (Personal information collection method)")
                        .font(.headline)
                    Text(
"""
The company collects users' personal information in the following ways.
**1. How users enter their personal information through GitHub service**

""").font(.footnote)
                    
                    Text("Article 7 (Use of Personal Information)")
                        .font(.headline)
                    Text(
"""
The company uses personal information in the following cases.
**1.** When it is necessary for the operation of the company, such as delivery of announcements
**2.** In the case of improving service to users, such as replying to inquiries about use and handling complaints
**3.** For providing the company's services
**4.** For developing new services
**5.** For marketing such as events and event information
**6.** For demographic analysis, analysis of service visits and usage records
**7.** In the case of forming a relationship between users based on personal information and interest
**8.** In the case of preventing and sanctioning acts that interfere with smooth operation of the service, including restricting use of members who violate laws and company terms and conditions, and illegal use

""").font(.footnote)
                    
                    Text("Article 8 (Provision of personal information according to prior consent, etc.)")
                        .font(.headline)
                    Text(
"""
**1.** Despite the ban on providing personal information to third parties, the company may provide personal information to third parties if the user discloses in advance or agrees to the following items. However, even in this case, the company provides personal information to a minimum within the relevant laws and regulations.
     **a.** Provide **GitHub user information** to **GitHub** for **user information update**
**2.** The company seeks notification and consent from users through the same procedure when there is a change in the third party provision relationship in the preceding paragraph or when the third party provision relationship is terminated.

""").font(.footnote)
                    
                    Text("Article 9 (Consignment of personal information processing)")
                        .font(.headline)
                    Text(
"""
The company entrusts the processing of personal information as follows in order to provide smooth service and process effective business.

**1.** To **Google** For the use of **Google Analytics 4**, an app event analysis tool **1. Personal information processing is consigned upon membership withdrawal or during the period of using Google Analytics 4**

""").font(.footnote)
                    
                    Text("Article 10 (Retention and Use Period of Personal Information)")
                        .font(.headline)
                    Text(
"""
**1.** The company retains and uses personal information for the period to achieve the purpose of collection and use of personal information of users.
**2.** Notwithstanding the preceding clause, the company keeps records of fraudulent use of the service for up to one year from the time of membership withdrawal to prevent fraudulent subscription and use according to internal policy.

""").font(.footnote)
                } // Group
                
                Group {
                    Text("Article 11 (Period of retention and use of personal information according to laws and regulations)")
                        .font(.headline)
                    Text(
"""
The company retains and uses personal information in accordance with the relevant laws and regulations as follows.

**1.** Retention information and retention period according to the Consumer Protection Act in Electronic Commerce, etc.
     **a.** Records on contract or subscription withdrawal: 5 years
     **b.** Records on payment and supply of goods: 5 years
     **c.** Records on consumer complaints or dispute handling: 3 years
     **d.** Records on display and advertisement: 6 months
**2.** Retention information and retention period under the Protection of Communications Secrets Act
     **a.** Website log records: 3 months
**3.** Retention information and retention period according to the Electronic Financial Transactions Act
     **a.** Records on electronic financial transactions: 5 years
**4.** Law on Protection and Use of Location Information
     **a.** Records on personal location information: 6 months

""").font(.footnote)
                    
                    Text("Article 12 (Principle of Destruction of Personal Information)")
                        .font(.headline)
                    Text(
"""
In principle, the company destroys the information without delay if the personal information is not necessary, such as the achievement of the purpose of processing the user's personal information or the expiration of the retention/use period.

""").font(.footnote)
                    
                    Text("Article 13 (Processing personal information of non-users of the service)")
                        .font(.headline)
                    Text(
"""
**1.** In principle, the company notifies the user in advance of the personal information of users who have not used the company's services for one year, and destroys or separately stores the personal information.
**2.** The company separates and safely stores the personal information of users who have not used it for a long time, and the notification of the user is sent to the e-mail address at least 30 days prior to the date of the separate storage processing.
**3.** Long-term non-users can log in to GitSpace if they want to continue using the service before the company separates the non-user DB separately.
**4.** Users who have not used the service for a long period of time can restore their account when logging in to GitSpace according to the user's consent.
**5.** The company destroys the separated personal information without delay after keeping it for 4 years.

""").font(.footnote)
                    
                    Text("Article 14 (Personal Information Destruction Procedure)")
                        .font(.headline)
                    Text(
"""
**1.** The information entered by the user for membership registration, etc. is transferred to a separate DB after the purpose of processing personal information is achieved (separate filing cabinet in case of paper), Refer to the period of use) After being stored for a certain period of time, it is destroyed.
**2.** The company destroys the personal information for which the reason for destruction occurred through the approval process of the person in charge of personal information protection.

""").font(.footnote)
                    
                    Text("Article 15 (Personal Information Destruction Method)")
                        .font(.headline)
                    Text(
"""
The company deletes personal information stored in the form of electronic files using a technical method that cannot reproduce records, and personal information printed on paper is shredded with a shredder or destroyed by incineration.

""").font(.footnote)
                } // Group
                
                Group {
                    Text("Article 16 (Transmission of Advertising Information)")
                        .font(.headline)
                    Text(
"""
**1.** When the company transmits advertising information for commercial purposes using electronic transmission media, the user's explicit prior consent is obtained. However, prior consent is not obtained in any of the following cases:
     **a.** If the company collects the contact information directly from the recipient through a transaction relationship with goods, etc., the company processes it within 6 months from the date the transaction ends and transmits commercial advertising information about the same kind of goods as the transaction with the recipient
     **b.** In case a telephone solicitation seller under the 「Door-to-Door Sales Act」 notifies the recipient of the collection source of personal information by voice and makes a telephone solicitation
**2.** Notwithstanding the preceding paragraph, if the recipient expresses his or her intention to reject the message or withdraws prior consent, the company will not transmit commercial advertising information and notify the result of the rejection or withdrawal of the message.
**3.** When the company transmits advertisement information for commercial purposes using electronic transmission media from 9:00 pm to 8:00 am the next day, separate prior consent is obtained from the recipient, notwithstanding paragraph 1.
**4.** When the company transmits advertising information for commercial purposes using electronic transmission media, the following matters are specifically disclosed in the advertising information.
     **a.** Company name and contact information
     **b.** Indication of matters concerning rejection of reception or expression of intention to withdraw consent to reception
**5.** The company does not take any of the following measures when transmitting commercial-purpose advertising information using electronic transmission media.
     **a.** Measures to avoid or hinder the recipient of advertising information from refusing to receive or withdrawing consent to receiving
     **b.** Measures to automatically create the recipient's contact information, such as phone number and e-mail address, by combining numbers, codes, or letters;
     **c.** Measures to automatically register a phone number or e-mail address for the purpose of transmitting advertising information for commercial purposes
     **d.** Various measures to hide the identity of the sender of advertising information or the source of advertisement transmission
     **e.** Various measures to induce replies by deceiving recipients for the purpose of transmitting advertising information for commercial purposes

""").font(.footnote)
                    
                    Text("Article 17 (Personal Information Inquiry and Withdrawal of Consent to Collection)")
                        .font(.headline)
                    Text(
"""
**1.** Users and legal representatives can view or modify their registered personal information at any time and request withdrawal of consent to personal information collection.
**2.** Users and legal representatives should contact the person in charge of personal information protection or the person in charge in writing, by phone or e-mail to withdraw their consent to the collection of their subscription information, and the company will take action without delay.

""").font(.footnote)
                    
                    Text("Article 18 (Personal information change, etc.)")
                        .font(.headline)
                    Text(
"""
**1.** The user may request the company to correct errors in personal information through the method of the preceding article.
**2.** In the case of the preceding paragraph, the company does not use or provide personal information until the correction of personal information is completed, and if the wrong personal information has already been provided to a third party, the company notifies the third party of the result of correction without delay and corrects it. We will make this happen.

""").font(.footnote)
                    
                    Text("Article 19 (Obligations of Users)")
                        .font(.headline)
                    Text(
"""
**1.** Users must keep their personal information up-to-date, and users are responsible for problems arising from incorrect information input by users.
**2.** If you sign up for membership by stealing other people's personal information, you may lose your user qualification or be punished under the relevant personal information protection laws.
**3.** Users are responsible for maintaining the security of their e-mail address and password, and cannot transfer or lend it to a third party.

""").font(.footnote)
                    
                    Text("Article 20 (Management of personal information of the company)")
                        .font(.headline)
                    Text(
"""
In processing the personal information of users, the company is taking the following technical and managerial protection measures to ensure safety so that personal information is not lost, stolen, leaked, falsified, or damaged.

""").font(.footnote)
                }
                
                Group {
                    Text("Article 21 (Processing of Deleted Information)")
                        .font(.headline)
                    Text(
"""
The company handles personal information that has been canceled or deleted at the request of a user or legal representative as specified in the "Period of Retention and Use of Personal Information" collected by the company and prevents it from being viewed or used for any other purpose.

""").font(.footnote)
                    
                    Text("Article 22 (Password Encryption)")
                        .font(.headline)
                    Text(
"""
The user's password is stored and managed with one-way encryption, and confirmation and change of personal information is possible only by the person who knows the password.

""").font(.footnote)
                    
                    Text("Article 23 (Measures against hacking, etc.)")
                        .font(.headline)
                    Text(
"""
**1.** The company is doing its best to prevent leakage or damage of users' personal information due to information and communication network intrusions such as hacking and computer viruses.
**2.** The company uses the latest vaccine program to prevent users' personal information or data from being leaked or damaged.
**3.** The company is doing its best in security by using an intrusion prevention system in preparation for emergencies.
**4.** The company ensures that sensitive personal information (if collected and retained) can be safely transmitted over the network through encrypted communication.

""").font(.footnote)
                    
                    Text("Article 24 (Minimization of Personal Information Processing and Education)")
                        .font(.headline)
                    Text(
"""
The company limits the person in charge of handling personal information to a minimum, and emphasizes compliance with laws and internal policies through administrative measures such as training for personal information processors.

""").font(.footnote)
                    
                    Text("Article 25 (Measures against leakage of personal information, etc.)")
                        .font(.headline)
                    Text(
"""
When the company is aware of the loss, theft or leakage of personal information (hereinafter referred to as “leakage, etc.”), it immediately informs the user of all matters in each of the following subparagraphs and reports it to the Korea Communications Commission or the Korea Internet and Security Agency.

**1.** Items of personal information that have been leaked
**2.** The time of leakage, etc.
**3.** Actions users can take
**4.** Countermeasures by information and communication service providers, etc.
**5.** Departments and contact information where users can receive consultations, etc.

""").font(.footnote)
                } // Group
                
                Group {
                    Text("Article 26 (Exceptions to Measures for Personal Information Leakage, etc.)")
                        .font(.headline)
                    Text(
"""
Despite the foregoing, if there is a legitimate reason, such as not being able to know the user's contact information, the company may take action in lieu of the notice in the preceding article by posting it on the company's homepage for more than 30 days.

""").font(.footnote)
                    
                    Text("Article 27 (Designation of the company's personal information manager)")
                        .font(.headline)
                    Text(
"""
**1.** In order to protect users' personal information and handle complaints related to personal information, the company appoints the relevant department and personal information manager as follows.
     **a.** Personal Information Protection Officer and Person in Charge
         **ⅰ.** Department in charge: RBG Management Support Team
         **ⅱ.** Name: Hanho Choi
         **ⅲ.** Email: gitspace.rbg@gmail.com
**2.** The company operates a department dedicated to personal information protection to protect personal information, and checks compliance with the personal information processing policy and compliance with the person in charge. there is.

""").font(.footnote)
                    
                    Text("Supplements")
                        .font(.headline)
                    Text(
"""
**Article 1.** This policy is effective from **2023.04.03**.

""").font(.footnote)
                    
                    Text("Copyright (c) 2023 **GitSpace**")
                        .font(.footnote)
                } // Group
                
            } // VStack
            .padding(.horizontal, 20)
        } // ScollView
        .multilineTextAlignment(.leading)
        .navigationBarTitle("Terms of Service & Privacy Policy")
    }
    
    
    
    //    var urlToLoad: String
    //    //uiview 만들기
    //    func makeUIView(context: Context) -> WKWebView {
    //        //언래핑
    //        guard let url = URL(string: urlToLoad) else{
    //            return WKWebView()
    //        }
    //        //웹뷰 인스턴스 생성
    //        let webview = WKWebView()
    //        //웹뷰 로드
    //        webview.load(URLRequest(url: url))
    //
    //        return webview
    //    }
    //
    //    //uiview 업데이트
    //    //context는 uiviewrepresentablecontext로 감싸야 함.
    //    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<TermsOfServiceView>) {
    //
    //    }
}

struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServiceView()
        //        TermsOfServiceView(urlToLoad: "https://industrious-expansion-4bf.notion.site/1fe25eb31ca541f8b82a97f87bce81c0")
    }
}
