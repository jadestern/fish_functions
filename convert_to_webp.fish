function convert_to_webp
    # 일반적으로 사용되는 이미지 파일 확장자
    for file in *.jpg *.jpeg *.png *.gif *.bmp *.tiff
        if test -f "$file"
            # 파일 MIME 타입 확인
            set -l mime_type (file --mime-type -b "$file" 2>/dev/null)
            if not string match -q -r '^image/' -- "$mime_type"
                # echo "건너뜀: 이미지 파일이 아닙니다: $file ($mime_type)" >&2
                continue
            end

            set basename (string split -r -m1 . "$file")[1]
            set output_file "$basename.webp"
            
            # 원본 파일 크기 가져오기
            set original_size (stat -f %z "$file" 2>/dev/null)
            if not test $status -eq 0; or not test "$original_size" -gt 0
                echo "오류: 원본 파일 크기를 가져올 수 없습니다: $file" >&2
                continue
            end

            # -quiet 옵션 사용
            cwebp -quiet -q 90 "$file" -o "$output_file"
            
            # 변환 결과 확인 및 크기 비교
            if test $status -eq 0
                set new_size (stat -f %z "$output_file" 2>/dev/null)
                if test $status -eq 0; and test "$new_size" -ge 0 # new_size가 0일 수도 있음
                    # 백분율 계산 (소수점 첫째 자리까지)
                    set reduction_pct (math --scale=1 "100 * ($original_size - $new_size) / $original_size")
                    echo "성공: $file -> $output_file (크기: $original_size -> $new_size bytes, $reduction_pct% 감소)"
                else
                    echo "성공 (크기 확인 불가): $file -> $output_file"
                end
                # 원본 파일 삭제
                rm "$file"
            else
                echo "실패: $file 변환 오류" >&2 # 실패 시 에러 메시지만 표준 에러로 출력
            end
        end
    end
end