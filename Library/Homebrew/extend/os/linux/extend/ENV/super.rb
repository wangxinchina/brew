module Superenv
  # @private
  def self.bin
    (HOMEBREW_SHIMS_PATH/"linux/super").realpath
  end

  def homebrew_extra_paths
    paths = []
    binutils = Formula["binutils"]
    paths << binutils.opt_bin if binutils.installed?
    paths
  rescue FormulaUnavailableError
    # Fix for brew tests, which uses NullLoader.
    []
  end

  def determine_rpath_paths
    paths = ["#{HOMEBREW_PREFIX}/lib"]
    paths += run_time_deps.map { |d| d.opt_lib.to_s }
    paths += homebrew_extra_library_paths
    paths.to_path_s
  end

  def determine_dynamic_linker_path(formula)
    if formula && formula.name == "glibc"
      ""
    else
      "#{HOMEBREW_PREFIX}/lib/ld.so"
    end
  end
end
