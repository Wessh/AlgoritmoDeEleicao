class Processo
  def initialize(n)
    @lista = (1..n).to_a
  end
end

class ProcessoBully < Processo
  def detecta_crash(pid)
    raise ArgumentError, "PID maior que a quantidade de processos criados!" if pid > @lista.size
    raise ArgumentError, "PID deve ser maior que 0!" if pid <= 0

    $coordenador = nil
    while $coordenador.nil? do
      if pid == @lista.last
        $coordenador = pid
      else
        maiores = @lista.select {|processo| processo > pid}

        maiores.each do |processo|
          puts "#{pid} -> #{processo}: ELEICAO\n"
        end

        maiores.each do |processo|
          puts "#{processo} -> #{pid}: OK\n"
        end

        puts "---------------\n"

        pid += 1
      end
    end

    @lista.pop
    @lista.each do |processo|
      puts "#{$coordenador} -> #{processo}: COORDENADOR\n"
    end
  end
end

class ProcessoRing < Processo
  def detecta_crash(pid)
    raise ArgumentError, "PID maior que a quantidade de processos criados!" if pid > @lista.size
    raise ArgumentError, "PID deve ser maior que 0!" if pid <= 0

    $i = pid
    while true
      if @lista[$i].nil?
        proximo = @lista[0]
        processo = $i
        $i = 0
      else
        proximo = @lista[$i]
        processo = $i
      end

      puts "#{processo} -> #{proximo}: ELEICAO(#{pid})\n"

      if pid == proximo
        break
      elsif pid < proximo
        pid = proximo
      end
      $i += 1
    end

    $i = pid
    while true
      if @lista[$i].nil?
        proximo = @lista[0]
        processo = $i
        $i = 0
      else
        proximo = @lista[$i]
        processo = $i
      end

      puts "#{processo} -> #{proximo}: COORDENADOR(#{pid})\n"

      break if pid == proximo

      $i += 1
    end
  end
end

puts "Informe o numero de processo:\n"
n = gets.chomp.to_i
raise ArgumentError, "Numero de processos deve ser >= 2" if n < 2

puts "Informe qual algoritmo de eleicao utilizar - (a)nel ou (b)ully:\n"
algoritmo = gets.chomp.downcase

if algoritmo == "a"
  processo = ProcessoRing.new n
elsif algoritmo == "b"
  processo = ProcessoBully.new n
else
  raise ArgumentError, "Algoritmo invalido!"
end

puts "Informe o PID do processo que inicia eleicao:\n"
processo.detecta_crash gets.chomp.to_i