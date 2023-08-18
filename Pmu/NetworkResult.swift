//
//  NetworkResult.swift
//  Pmu
//
//  Created by seohuibaek on 2023/08/16.
//

import Foundation

enum NetworkResult<T> {
    case success(T) //200
    case badRequest //400 잘못된 요청
    case unauthorized //401 리소스 접근 권한 없음, 토큰 조회 오류
    case forbidden // 403 리소스 접근 권한 없음
    case notFound //404 엔티티 없거나, 회원 찾기 불가
    case methodNotAllowed //405 잘못된 HTTP method 요청
    case conflict //409 이미 존재하는 리소스
    case internalServerError // 500 서버 내부 오류
    case unknown
}
