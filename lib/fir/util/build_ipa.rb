# frozen_string_literal: true

module FIR
  module BuildIpa
    def build_ipa(*_args, _options)
      logger.error "fir build ipa \b功能已过期, 请及时迁移打包部分, 推荐使用 fastlane gym 生成ipa 后再使用 fir-cli 上传"
    end

    private
  end
end
