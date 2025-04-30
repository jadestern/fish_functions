function extract_each
    # 현재 경로의 모든 디렉토리를 찾습니다.
    for dir in */
        # 디렉토리인지 확인합니다 (슬래시 제거).
        set -l dirname (string trim -r -c '/' -- $dir)

        if test -d "$dirname"
            echo "압축 중: $dirname"
            # zip 명령어를 사용하여 디렉토리를 압축합니다.
            # -r 옵션은 재귀적으로 압축하고, -q 옵션은 조용히 실행합니다.
            zip -r -q "$dirname.zip" "$dirname"

            if test $status -eq 0
                echo "성공: $dirname -> $dirname.zip"
            else
                echo "실패: $dirname 압축 오류" >&2
            end
        end
    end
end
