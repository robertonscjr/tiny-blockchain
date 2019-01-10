import System.IO  
import Data.List

-- DATA TYPES
data Transacao = Transacao {
sender :: Int,
receiver :: Int,
valor :: Int } deriving (Show)

data Bloco = Bloco {
index :: Int,
timestamp :: Int,
dados :: [Transacao],
hashAnterior :: String,
hash :: String} deriving (Show)


-- HASH FUNCTION
getHash :: String -> String
getHash plain = reverse plain


-- BLOCK FUNCTIONS
blocoGenesis :: Bloco
blocoGenesis = Bloco 0 0 [Transacao 7 0 1000, Transacao 7 1 1000] "before" "genesis"

criarBloco :: Bloco -> [Transacao] -> Bloco
criarBloco lb pool = Bloco (index lb + 1) (timestamp lb + 1) (dados lb ++ pool) (hash lb) (getHash (hash lb))

addBlocoOnFileIO bloco file = writeFile file $ show (index bloco) ++ "-" ++ show (timestamp bloco) ++ "-" ++ concat (intersperse "," $ map formatTransacao $ dados bloco) ++ "-" ++ show (hashAnterior bloco) ++ "-" ++ show (hash bloco) ++ "\n"


-- TRANSACTION FUNCTIONS
formatTransacao tx = show (sender tx) ++ "." ++ show (receiver tx) ++ "." ++ show (valor tx)

criarTransacao :: Int -> Int -> Transacao
criarTransacao sender value = Transacao sender (mod (sender-1) 2) value

obterTransacaoIO :: String -> Transacao
obterTransacaoIO str_tx = Transacao (read((split str_tx '.')!!0)) (read((split str_tx '.')!!1)) (read((split str_tx '.')!!2))

obterTransacoesIO :: String -> [Transacao]
obterTransacoesIO str_txs = map obterTransacaoIO (split str_txs ',')

obterPoolTransacaoIO :: String -> Transacao
obterPoolTransacaoIO tx = criarTransacao (read (split tx ',' !! 0)) (read (split tx ',' !! 1))


-- MAIN
main :: IO ()
main = do
   addBlocoOnFileIO blocoGenesis "chain.txt"
   addBlocoOnFileIO blocoGenesis "chain_log.txt"
   writeFile "chain_tmp.txt" ""
   writeFile "pool.txt" ""
   mytinyblockchain


-- MENU
mytinyblockchain :: IO ()
mytinyblockchain = do
   putStrLn "MyTinyBlockchain"
   putStrLn . unlines $ map concatNums opcoes
   choice <- getLine
   case validaOpcao choice of
      Just n  -> execute . read $ choice
      Nothing -> putStrLn "Digite uma opcao valida"
   
   mytinyblockchain
  where concatNums (i, (s, _)) = show i ++ ". " ++ s

validaOpcao :: String -> Maybe Int
validaOpcao s = isValid (reads s)
  where isValid []            = Nothing
        isValid ((n, _):_) 
              | outOfBounds n = Nothing
              | otherwise     = Just n
        outOfBounds n = (n < 1) || (n > length opcoes)

opcoes :: [(Int, (String, IO ()))]
opcoes = zip [1.. ] [
   ("Enviar dinheiro", enviarDinheiroIO)
  ,("Exibir saldo", exibirSaldoIO)
  ,("Minerar bloco", minerarBlocoIO)
  ,("Exibir transacoes pendentes", exibirTransacoesPendentesIO)
  ,("Sair", sairIO)
 ]

execute :: Int -> IO ()
execute n = doExec $ filter (\(i, _) -> i == n) opcoes
  where doExec ((_, (_,f)):_) = f


-- IO FUNCTIONS
enviarDinheiroIO :: IO ()
enviarDinheiroIO = do
   putStrLn "Enviar dinheiro"

   putStrLn "Sender (0 para Alice e 1 para Bob): "
   sender <- getLine
   
   putStrLn "Valor: "
   valor <- getLine

   appendFile "pool.txt" $ sender ++ "," ++ valor ++ "\n"

   putStrLn "Transacao adicionada ao buffer de transacoes a serem mineradas"

   putStrLn "Para efetivar a transacao, minere um bloco"

exibirSaldoIO :: IO()    
exibirSaldoIO = do
   putStrLn "Exibir saldo"
   chain <- (readFile "chain.txt")
   let chain_params = init (split chain '\n')
   let params = chain_params !! 0
   let formatted = split params '-'
   let bloco = Bloco (read (formatted !! 0)) (read (formatted !! 1)) (obterTransacoesIO (formatted !! 2)) (formatted !! 3) (formatted !! 4)

   let txs = dados bloco

   let alice_plus _txs = sum [valor x | x <- _txs, receiver x == 0]
   let alice_minus _txs = sum [valor x | x <- _txs, sender x == 0]
   let alice_sum = show (alice_plus txs - alice_minus txs)

   let bob_plus _txs = sum [valor x | x <- _txs, receiver x == 1]
   let bob_minus _txs = sum [valor x | x <- _txs, sender x == 1]
   let bob_sum = show (bob_plus txs - bob_minus txs)

   putStrLn ("Alice: " ++ alice_sum)
   putStrLn ("Bob: " ++ bob_sum)


minerarBlocoIO :: IO()
minerarBlocoIO = do
   putStrLn "Minera bloco"
   -- MINERAR BLOCO (VICTOR)
   putStrLn "Registrando novo bloco na blockchain"
   chain <- (readFile "chain.txt")
   txs_raw <- (readFile "pool.txt")             
   let chain_params = init (split chain '\n')
   let params = chain_params !! 0
   let formatted = split params '-'
   let bloco = Bloco (read (formatted !! 0)) (read (formatted !! 1)) (obterTransacoesIO (formatted !! 2)) (formatted !! 3) (formatted !! 4)

   let txs_lines = init (split txs_raw '\n')
   let txs = map obterPoolTransacaoIO txs_lines

   let newBloco = criarBloco bloco txs
   writeFile "chain_tmp.txt" $ show (index newBloco) ++ "-" ++ show (timestamp newBloco) ++ "-" ++ concat (intersperse "," $ map formatTransacao $ dados newBloco) ++ "-" ++ show (hashAnterior newBloco) ++ "-" ++ show (hash newBloco) ++ "\n"
 
   writeFile "pool.txt" ""
   updateBlockchainIO




    chain <- (readFile "chain.txt")
    txs_raw <- (readFile "pool.txt")             
    let chain_params = init (split chain '\n')
    let params = chain_params !! 0
    let formatted = split params '-'
    let bloco = Bloco (read (formatted !! 0)) (read (formatted !! 1)) (obterTransacoesIO (formatted !! 2)) (formatted !! 3) (formatted !! 4)
 
    let txs_lines = init (split txs_raw '\n')
    let txs = map obterPoolTransacaoIO txs_lines
 
    let newBloco = criarBloco bloco txs
    writeFile "chain_tmp.txt" $ show (index newBloco) ++ "-" ++ show (timestamp newBloco) ++ "-" ++ concat (intersperse "," $ map formatTransacao $ dados newBloco) ++ "-" ++ show (hashAnterior newBloco) ++ "-" ++ show (hash newBloco) ++ "\n"
  
    writeFile "pool.txt" ""
    updateBlockchainIO

updateBlockchainIO :: IO()
updateBlockchainIO = do
   new_chain <- readFile "chain_tmp.txt"
   writeFile "chain.txt" new_chain
   appendFile "chain_log.txt" new_chain


exibirTransacoesPendentesIO :: IO()
exibirTransacoesPendentesIO = do
   putStrLn "Exibir transações pendentes"
   putStrLn "Transacoes pendentes:"
   txs_raw <- (readFile "pool.txt")
      
   putStrLn txs_raw

sairIO :: IO()
sairIO = do
   putStrLn "Sair"


-- UTILS
split :: String -> Char -> [String]
split [] delim = [""]
split (c:cs) delim
    | c == delim = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = split cs delim
