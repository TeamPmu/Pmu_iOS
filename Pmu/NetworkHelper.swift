//
//  NetworkHelper.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/18.
//

import Foundation

struct NetworkHelper {
    private init() {}
    
    // 상태 코드와 데이터, decoding type을 가지고 통신의 결과를 핸들링하는 함수
    static func parseJSON<T: Codable> (by statusCode: Int, data: Data, type: T.Type) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        guard let decodedData = try? decoder.decode(KakaoLoginResponse<T>.self, from: data) else { return .badRequest }
        
        switch statusCode {
        case 200..<300: return .success(decodedData)
        case 400: return .badRequest //400 잘못된 요청
        case 401: return .unauthorized //401 리소스 접근 권한 없음, 토큰 조회 오류
        case 403: return .forbidden // 403 리소스 접근 권한 없음
        case 404: return .notFound //404 엔티티 없거나, 회원 찾기 불가
        case 405: return .methodNotAllowed //405 잘못된 HTTP method 요청
        case 409: return .conflict //409 이미 존재하는 리소스
        case 500: return .internalServerError // 500 서버 내부 오류
        default: return .unknown
        }
    }
}
